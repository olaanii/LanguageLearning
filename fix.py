import os
import re

def fix(path):
    with open(path, 'r', encoding='utf-8') as f: content = f.read()
    content = content.replace("import '../providers/auth_provider.dart';", "import '../../features/auth/presentation/state/auth_provider.dart';")
    content = content.replace("import '../../providers/auth_provider.dart';", "import '../../../features/auth/presentation/state/auth_provider.dart';")
    content = content.replace("import '../constants/theme.dart';", "import '../../core/theme/app_theme.dart';")
    content = content.replace("import '../../constants/theme.dart';", "import '../../../core/theme/app_theme.dart';")
    content = re.sub(r'\bUser\(', 'UserEntity(', content)
    content = re.sub(r'\bUser\b(?!Entity)', 'UserEntity', content)
    with open(path, 'w', encoding='utf-8') as f: f.write(content)

for d, _, fs in os.walk('lib/screens'):
    for f in fs:
        if f.endswith('.dart'): fix(os.path.join(d, f))
