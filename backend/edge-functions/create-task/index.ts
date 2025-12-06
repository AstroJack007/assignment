import { serve } from "std/http/server.ts";
import { createClient } from "@supabase/supabase-js";

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

type CreateTaskPayload = {
  application_id: string;
  task_type: string;
  due_at: string;
};

const VALID_TYPES = ["call", "email", "review"];

serve(async (req: Request) => {
  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { "Content-Type": "application/json" },
    });
  }

  try {
    const body = (await req.json()) as Partial<CreateTaskPayload>;
    const { application_id, task_type, due_at } = body;

    if (!application_id || !task_type || !due_at) {
      return new Response(JSON.stringify({ error: "Missing required fields" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    if (!VALID_TYPES.includes(task_type)) {
      return new Response(JSON.stringify({ error: "Invalid task_type" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const dueDate = new Date(due_at);
    if (isNaN(dueDate.getTime())) {
      return new Response(JSON.stringify({ error: "Invalid due_at format" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }
    if (dueDate <= new Date()) {
      return new Response(JSON.stringify({ error: "due_at must be in the future" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const { data: appData, error: appError } = await supabase
      .from("applications")
      .select("tenant_id")
      .eq("id", application_id)
      .single();

    if (appError || !appData) {
      return new Response(JSON.stringify({ error: "Application not found" }), {
        status: 400,
        headers: { "Content-Type": "application/json" },
      });
    }

    const { data: taskData, error: taskError } = await supabase
      .from("tasks")
      .insert({
        tenant_id: appData.tenant_id,
        application_id,
        type: task_type,
        due_at,
        status: 'open'
      })
      .select()
      .single();

    if (taskError) {
      throw taskError;
    }

    return new Response(JSON.stringify({ success: true, task_id: taskData.id }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });

  } catch (err) {
    console.error(err);
    return new Response(JSON.stringify({ error: "Internal server error" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
