Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085236AC2B2
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 15:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCFOMr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 09:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbjCFOMZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 09:12:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ABC2820A
        for <live-patching@vger.kernel.org>; Mon,  6 Mar 2023 06:09:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678111709;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=djmf7VYZwrWQPrKhg3rfMb09otmSQIVe2MqSC5L6dA0=;
        b=IJ/DZD/Bbo/ox+nlmt3pCdNsTFA6lJK2pxnGoFaCk+/rsJC5r9bRHWFwvPv6IThkQNBxxi
        RB98+DcKbXdOYlDFDZkDHmWnqqvhFlMsK/Xo7hMu7i/XRx2nSslx8te/5+aW3IL48xUkW9
        hY6kPD1rnfnzMWw7uhnYZoP+u1XWExU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-202-wr7Yf1G2Oz6JWpOJG11CBQ-1; Mon, 06 Mar 2023 09:08:27 -0500
X-MC-Unique: wr7Yf1G2Oz6JWpOJG11CBQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A5D281C05AD7;
        Mon,  6 Mar 2023 14:08:26 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.17.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A67840C1106;
        Mon,  6 Mar 2023 14:08:26 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v7 00/10] livepatch: klp-convert tool
Date:   Mon,  6 Mar 2023 09:08:14 -0500
Message-Id: <20230306140824.3858543-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Summary
-------

Livepatches may use symbols which are not contained in its own scope,
and, because of that, may end up compiled with relocations that will
only be resolved during module load. Yet, when the referenced symbols
are not exported, solving this relocation requires information on the
object that holds the symbol (either vmlinux or modules) and its
position inside the object, as an object may contain multiple symbols
with the same name.  Providing such information must be done accordingly
to what is specified in Documentation/livepatch/module-elf-format.txt.

Currently, there is no trivial way to embed the required information as
requested in the final livepatch elf object. klp-convert solves this
problem in two different forms: (i) by relying on a symbol map, which is
built during kernel compilation, to automatically infer the relocation
targeted symbol, and, when such inference is not possible (ii) by using
annotations in the elf object to convert the relocation accordingly to
the specification, enabling it to be handled by the livepatch loader.

Given the above, add support for symbol mapping in the form of a
symbols.klp file; add klp-convert tool; integrate klp-convert tool into
kbuild; make livepatch modules discernible during kernel compilation
pipeline; add data-structure and macros to enable users to annotate
livepatch source code; make modpost stage compatible with livepatches;
update livepatch-sample and update documentation.

The patch was tested under three use-cases:

use-case 1: There is a relocation in the lp that can be automatically
resolved by klp-convert.  For example. see the saved_command_line
variable in lib/livepatch/test_klp_convert2.c.

use-case 2: There is a relocation in the lp that cannot be automatically
resolved, as the name of the respective symbol appears in multiple
objects. The livepatch contains an annotation to enable a correct
relocation.  See the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections
in lib/livepatch/test_klp_convert{1,2}.c.

use-case 3: There is a relocation in the lp that cannot be automatically
resolved similarly as 2, but no annotation was provided in the
livepatch, triggering an error during compilation.  Reproducible by
removing the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections in
lib/livepatch/test_klp_convert{1,2}.c.

Selftests have been added to exercise these klp-convert use-cases
through several tests.


Testing
-------

The patchset selftests build and execute on x86_64, s390x, and ppc64le
for both default config (with added livepatch dependencies) and a larger
RHEL-9-ish config.

Using the Intel's Linux Kernel Performance tests's make.cross,
klp-convert builds and processes livepatch .ko's for x86_64 ppc64le
ppc32 s390 arm64 arches.


Summary of changes in v7
------------------------

- rebase for v6.2
- combine ("livepatch: Add klp-convert tool") with ("livepatch: Add
  klp-convert annotation helpers")
- combine ("kbuild: Support for symbols.klp creation") with ("modpost:
  Integrate klp-convert") to simplify Kbuild magic [Petr, Nicolas]
- klp-convert: add safe_snprintf() (-Wsign-compare)
- klp-convert: fix -Wsign-compare warnings
- klp-convert: use calloc() where appropriate
- klp-convert: copy ELF e_flags
- selftests: fix various build warnings
- klp-convert: WARN msg simplification, failed sanity checks, and sympos
  comment [Marcos]
- klp-convert: fix elf_write_file() error paths [Petr]


Previous versions
-----------------

RFC:
  https://lore.kernel.org/lkml/cover.1477578530.git.jpoimboe@redhat.com/
v2:
  https://lore.kernel.org/lkml/f52d29f7-7d1b-ad3d-050b-a9fa8878faf2@redhat.com/
v3:
  https://lore.kernel.org/lkml/20190410155058.9437-1-joe.lawrence@redhat.com/
v4:
  https://lore.kernel.org/lkml/20190509143859.9050-1-joe.lawrence@redhat.com/
v5:
  (not posted)
  https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v5-devel
v6:
  https://lore.kernel.org/live-patching/20220216163940.228309-1-joe.lawrence@redhat.com/


Joe Lawrence (10):
  livepatch: Create and include UAPI headers
  livepatch: Add klp-convert tool
  kbuild/modpost: create symbols.klp and integrate klp-convert
  livepatch: Add sample livepatch module
  documentation: Update on livepatch elf format
  livepatch/selftests: add klp-convert
  livepatch/selftests: test multiple sections
  livepatch/selftests: add __asm__ symbol renaming examples
  livepatch/selftests: add data relocations test
  livepatch/selftests: add static keys test

 .gitignore                                    |   2 +
 Documentation/dontdiff                        |   1 +
 Documentation/livepatch/livepatch.rst         |   3 +
 Documentation/livepatch/module-elf-format.rst |  42 +-
 MAINTAINERS                                   |   2 +
 Makefile                                      |  16 +-
 include/linux/livepatch.h                     |  13 +
 include/uapi/linux/livepatch.h                |  25 +
 kernel/livepatch/core.c                       |   4 +-
 lib/livepatch/Makefile                        |  12 +
 lib/livepatch/test_klp_convert.h              |  45 +
 lib/livepatch/test_klp_convert1.c             | 121 +++
 lib/livepatch/test_klp_convert2.c             | 110 +++
 lib/livepatch/test_klp_convert_data.c         | 190 ++++
 lib/livepatch/test_klp_convert_keys.c         |  91 ++
 lib/livepatch/test_klp_convert_keys_mod.c     |  52 +
 lib/livepatch/test_klp_convert_mod_a.c        |  31 +
 lib/livepatch/test_klp_convert_mod_b.c        |  19 +
 lib/livepatch/test_klp_convert_mod_c.c        |  36 +
 lib/livepatch/test_klp_convert_sections.c     | 120 +++
 samples/livepatch/Makefile                    |   1 +
 .../livepatch/livepatch-annotated-sample.c    |  93 ++
 scripts/Makefile                              |   1 +
 scripts/Makefile.modfinal                     |  33 +
 scripts/Makefile.modpost                      |   5 +
 scripts/livepatch/.gitignore                  |   1 +
 scripts/livepatch/Makefile                    |   5 +
 scripts/livepatch/elf.c                       | 817 ++++++++++++++++
 scripts/livepatch/elf.h                       |  74 ++
 scripts/livepatch/klp-convert.c               | 893 ++++++++++++++++++
 scripts/livepatch/klp-convert.h               |  47 +
 scripts/livepatch/list.h                      | 391 ++++++++
 scripts/mod/modpost.c                         |  28 +-
 scripts/mod/modpost.h                         |   1 +
 .../selftests/livepatch/test-livepatch.sh     | 403 ++++++++
 35 files changed, 3716 insertions(+), 12 deletions(-)
 create mode 100644 include/uapi/linux/livepatch.h
 create mode 100644 lib/livepatch/test_klp_convert.h
 create mode 100644 lib/livepatch/test_klp_convert1.c
 create mode 100644 lib/livepatch/test_klp_convert2.c
 create mode 100644 lib/livepatch/test_klp_convert_data.c
 create mode 100644 lib/livepatch/test_klp_convert_keys.c
 create mode 100644 lib/livepatch/test_klp_convert_keys_mod.c
 create mode 100644 lib/livepatch/test_klp_convert_mod_a.c
 create mode 100644 lib/livepatch/test_klp_convert_mod_b.c
 create mode 100644 lib/livepatch/test_klp_convert_mod_c.c
 create mode 100644 lib/livepatch/test_klp_convert_sections.c
 create mode 100644 samples/livepatch/livepatch-annotated-sample.c
 create mode 100644 scripts/livepatch/.gitignore
 create mode 100644 scripts/livepatch/Makefile
 create mode 100644 scripts/livepatch/elf.c
 create mode 100644 scripts/livepatch/elf.h
 create mode 100644 scripts/livepatch/klp-convert.c
 create mode 100644 scripts/livepatch/klp-convert.h
 create mode 100644 scripts/livepatch/list.h

-- 
2.39.2

