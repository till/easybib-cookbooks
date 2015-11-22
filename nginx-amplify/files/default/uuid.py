#!/usr/bin/env python2
import platform, uuid
print(uuid.uuid5(uuid.NAMESPACE_DNS, platform.node() + str(uuid.getnode())).hex)
