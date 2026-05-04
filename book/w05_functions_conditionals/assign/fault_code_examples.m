% fault_code_examples

fault_code("Hi")
fault_code(3.14)

% Test matrix
tests = {
    [1], "Hull structure";
    [21:26], "Generation machinery",
    [231:235], "Generation gas turbines";
    [2341], "Main generation gas turbines";
    [23411], "Main generation gas turbine n1";
    [23412], "Main generation gas turbine n2"};

for ii = 1:size(tests,1)
    codes = tests{ii,1};
    for jj = 1:length(codes)
        code = codes(jj);
        msg = fault_code(code);
        fprintf("%d : %s : %d\n", code, msg, msg==tests{ii,2});
    end
end


