with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   size : Integer := 1000;
   task_elements : Integer := size / 4;

   type array_type is array(0..size-1) of Long_Integer;
   arr : array_type;

   result: Long_Integer := 0;
   part_sum_res : Long_Integer := 0;

   function partical_sum (first_ind, last_ind: Integer) return Long_Integer;

   function partical_sum (first_ind, last_ind: Integer) return Long_Integer is
      part_sum : Long_Integer := 0;
   begin
      for i in first_ind..last_ind loop
         part_sum := part_sum + arr(i);
      end loop;

      return part_sum;
   end partical_sum;

   task type part_sum_task is
      entry start(task_number : Integer);
      entry stop (result : out Long_Integer);
   end part_sum_task;

   task body part_sum_task is
      first_ind : Integer := 0;
      second_ind : Integer := 0;
      sum : Long_Integer := 0;

   begin
      accept start(task_number: Integer) do
         first_ind := task_number * task_elements;
         second_ind := (task_number + 1) * task_elements - 1;
      end start;

      sum := partical_sum (first_ind, second_ind);

      accept Stop (result : out Long_Integer) do
         result := sum;
      end Stop;

   end part_sum_task;

   part_sum_results_arr : array(0..3) of part_sum_task;
begin

   for i in 0..size - 1 loop
      arr(i) := long_integer(i);
   end loop;

   for i in part_sum_results_arr'Range loop
      part_sum_results_arr(i).start(i);
   end loop;

   for i in part_sum_results_arr'Range loop
      part_sum_results_arr(i).stop(part_sum_res);
      result := result + part_sum_res;
   end loop;

   Put_Line(result'Img);
end Main;

