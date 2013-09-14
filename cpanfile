requires 'perl', '5.008005';

requires 'parent';
requires 'Constant::Exporter';

requires 'Time::Piece';
requires 'Time::HiRes';

requires 'File::Spec';
requires 'File::Path';
requires 'File::Basename';

requires 'Sys::Hostname';
requires 'Hash::Flatten';

requires 'POSIX';
requires 'Fcntl';
requires 'Scalar::Util';
requires 'IO::Handle';

on test => sub {
    requires 'Test::More', '0.88';
    requires 'Test::LoadAllModules';
};
