Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7AC68D748
	for <lists+live-patching@lfdr.de>; Tue,  7 Feb 2023 13:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbjBGM6H (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Feb 2023 07:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjBGM6G (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Feb 2023 07:58:06 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE267DB1;
        Tue,  7 Feb 2023 04:58:05 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C799838DBE;
        Tue,  7 Feb 2023 12:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675774683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uC8rW1vgztaJvz1BqhV2czadU2bonbXSz3N1QcPJa1U=;
        b=egzoGaWrF7ZiPbTLSUnuRWuUOiK4NmApbxJ99o+fYrH7nIo1aXUaY1Kr3v5gct5xtt4N6Q
        cmQqhdOWjb7qiDgM313j3WWZUu0TSQykWy/ajQOdmv/6mQOYkRa0Iy/n6VrmjVoKL11EPS
        tWGIpsc6GVkbEQsucGB5jOYvk7KHsUs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675774683;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uC8rW1vgztaJvz1BqhV2czadU2bonbXSz3N1QcPJa1U=;
        b=MxB3awFOepaml8JOfvlke7MoORYnY0pjji2cPlqapHBJJzFFrWKfCWcusBmbozj8MkEeyZ
        gDLGnp2TvNXPf7Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7189D13467;
        Tue,  7 Feb 2023 12:58:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4HTcDtpK4mO1ZAAAMHmgww
        (envelope-from <mpdesouza@suse.de>); Tue, 07 Feb 2023 12:58:02 +0000
Date:   Tue, 7 Feb 2023 09:57:59 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [RFC PATCH v6 00/12] livepatch: klp-convert tool
Message-ID: <20230207125759.xfcsnlma6ezehff7@daedalus>
References: <20220216163940.228309-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216163940.228309-1-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 16, 2022 at 11:39:28AM -0500, Joe Lawrence wrote:
> This mostly a rebase update of the livepatch klp-convert tool used to
> generate klp-relocation types (explained in the summary below).
> 
> I'm marking this as an RFC as it hasn't been extensively tested for all
> livepatch supported arches.  There are may be a few symbol annotation
> changes pending what may be implemented for the FGKASLR patchset, I've
> left a few TODO and // question? marks in the code, etc.  At the same
> time, I think "CET/IBT support and live-patches" highlighted a potential
> need for this tooling, so I'm posting it in its current format for
> discussion.  I'll reply to individual patches to highlight a few points
> of interest.
> 
> 
> Summary
> -------
> 
> Livepatches may use symbols which are not contained in its own scope,
> and, because of that, may end up compiled with relocations that will
> only be resolved during module load. Yet, when the referenced symbols
> are not exported, solving this relocation requires information on the
> object that holds the symbol (either vmlinux or modules) and its
> position inside the object, as an object may contain multiple symbols
> with the same name.  Providing such information must be done accordingly
> to what is specified in Documentation/livepatch/module-elf-format.txt.
> 
> Currently, there is no trivial way to embed the required information as
> requested in the final livepatch elf object. klp-convert solves this
> problem in two different forms: (i) by relying on a symbol map, which is
> built during kernel compilation, to automatically infer the relocation
> targeted symbol, and, when such inference is not possible (ii) by using
> annotations in the elf object to convert the relocation accordingly to
> the specification, enabling it to be handled by the livepatch loader.
> 
> Given the above, add support for symbol mapping in the form of a
> symbols.klp file; add klp-convert tool; integrate klp-convert tool into
> kbuild; make livepatch modules discernible during kernel compilation
> pipeline; add data-structure and macros to enable users to annotate
> livepatch source code; make modpost stage compatible with livepatches;
> update livepatch-sample and update documentation.
> 
> The patch was tested under three use-cases:
> 
> use-case 1: There is a relocation in the lp that can be automatically
> resolved by klp-convert.  For example. see the saved_command_line
> variable in lib/livepatch/test_klp_convert2.c.
> 
> use-case 2: There is a relocation in the lp that cannot be automatically
> resolved, as the name of the respective symbol appears in multiple
> objects. The livepatch contains an annotation to enable a correct
> relocation.  See the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections
> in lib/livepatch/test_klp_convert{1,2}.c.
> 
> use-case 3: There is a relocation in the lp that cannot be automatically
> resolved similarly as 2, but no annotation was provided in the
> livepatch, triggering an error during compilation.  Reproducible by
> removing the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections in
> lib/livepatch/test_klp_convert{1,2}.c.
> 
> Selftests have been added to exercise these klp-convert use-cases
> through several tests.
> 
> 
> Branches
> --------
> 
> 
> Previous versions
> -----------------
> 
> RFC:
>   https://lore.kernel.org/lkml/cover.1477578530.git.jpoimboe@redhat.com/
> v2:
>   https://lore.kernel.org/lkml/f52d29f7-7d1b-ad3d-050b-a9fa8878faf2@redhat.com/
> v3:
>   https://lore.kernel.org/lkml/20190410155058.9437-1-joe.lawrence@redhat.com/
> v4:
>   https://lore.kernel.org/lkml/20190509143859.9050-1-joe.lawrence@redhat.com/
> v5:
>   (not posted)
>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v5-devel
> v6:
>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v6
>   https://github.com/joe-lawrence/klp-convert-tree/tree/klp-convert-v6-devel

Hi Joe,

I send reviews to some patches of the v6 batch, but there is currently a v7 in
your github profile. I believe that I sent Rb for patches that are the same
between versions.

The current version is almost one year older already. Do you plan to send v7
soon?

Thanks a lot!
  Marcos

> 
> 
> Summary of changes in v5
> ------------------------
> 
> [For/from Masahiro]
> - rename Symbols.list to symbols.klp
> - remove HOST_EXTRACFLAGS from klp-convert build
> - kbuild tweaks from Masahiro Yamada
> - SPDX instead of the license boilerplate
> 
> [Joe]
> - a bunch of small checkpatch, clang-check fixes
> - klp-convert: account for symbols shared across sections
> - klp-convert: sympos endianness for cross-compile
> - klp-convert: implement rela section support list
> - klp-convert: update group sections sh_link
> - klp-convert: flag annotations without relocations
> - klp-convert: allow .rela__jump_table to vmlinux
> - livepatch/selftests: Add __asm__ symbol renaming examples
> - livepatch/selftests: test multiple sections
> - livepatch/selftests: add static keys test
> 
> [Miroslav]
> - klp-convert: use _safe list traversals only when required
> - klp-convert: separate rela conversation from removal
> 
> 
> Summary of changes in v6
> ------------------------
> 
> [For/from Christophe]
> - klp-convert: Support for ppc32 ELF files
> 
> [Joe]
> - livepatch/selftests: add data relocations test
> - klp-convert: move relas to klp_rela_sec tail
> - rebase for v5.17-rc1
> 
> 
> Joao Moreira (2):
>   kbuild: Support for symbols.klp creation
>   documentation: Update on livepatch elf format
> 
> Joe Lawrence (5):
>   livepatch/selftests: add klp-convert
>   livepatch/selftests: test multiple sections
>   livepatch/selftests: add __asm__ symbol renaming examples
>   livepatch/selftests: add data relocations test
>   livepatch/selftests: add static keys test
> 
> Josh Poimboeuf (5):
>   livepatch: Create and include UAPI headers
>   livepatch: Add klp-convert tool
>   livepatch: Add klp-convert annotation helpers
>   modpost: Integrate klp-convert
>   livepatch: Add sample livepatch module
> 
>  .gitignore                                    |   2 +
>  Documentation/dontdiff                        |   1 +
>  Documentation/livepatch/livepatch.rst         |   3 +
>  Documentation/livepatch/module-elf-format.rst |  42 +-
>  MAINTAINERS                                   |   2 +
>  Makefile                                      |  12 +-
>  include/linux/livepatch.h                     |  13 +
>  include/uapi/linux/livepatch.h                |  25 +
>  kernel/livepatch/core.c                       |   4 +-
>  lib/livepatch/Makefile                        |  12 +
>  lib/livepatch/test_klp_convert.h              |  45 +
>  lib/livepatch/test_klp_convert1.c             | 121 +++
>  lib/livepatch/test_klp_convert2.c             | 110 +++
>  lib/livepatch/test_klp_convert_data.c         | 190 ++++
>  lib/livepatch/test_klp_convert_keys.c         |  91 ++
>  lib/livepatch/test_klp_convert_keys_mod.c     |  52 +
>  lib/livepatch/test_klp_convert_mod_a.c        |  31 +
>  lib/livepatch/test_klp_convert_mod_b.c        |  19 +
>  lib/livepatch/test_klp_convert_mod_c.c        |  36 +
>  lib/livepatch/test_klp_convert_sections.c     | 120 +++
>  samples/livepatch/Makefile                    |   1 +
>  .../livepatch/livepatch-annotated-sample.c    |  93 ++
>  scripts/Makefile                              |   1 +
>  scripts/Makefile.modfinal                     |  38 +-
>  scripts/Makefile.modpost                      |   5 +
>  scripts/livepatch/.gitignore                  |   1 +
>  scripts/livepatch/Makefile                    |   5 +
>  scripts/livepatch/elf.c                       | 813 ++++++++++++++++
>  scripts/livepatch/elf.h                       |  74 ++
>  scripts/livepatch/klp-convert.c               | 885 ++++++++++++++++++
>  scripts/livepatch/klp-convert.h               |  47 +
>  scripts/livepatch/list.h                      | 391 ++++++++
>  scripts/mod/modpost.c                         |  28 +-
>  scripts/mod/modpost.h                         |   1 +
>  .../selftests/livepatch/test-livepatch.sh     | 405 ++++++++
>  35 files changed, 3708 insertions(+), 11 deletions(-)
>  create mode 100644 include/uapi/linux/livepatch.h
>  create mode 100644 lib/livepatch/test_klp_convert.h
>  create mode 100644 lib/livepatch/test_klp_convert1.c
>  create mode 100644 lib/livepatch/test_klp_convert2.c
>  create mode 100644 lib/livepatch/test_klp_convert_data.c
>  create mode 100644 lib/livepatch/test_klp_convert_keys.c
>  create mode 100644 lib/livepatch/test_klp_convert_keys_mod.c
>  create mode 100644 lib/livepatch/test_klp_convert_mod_a.c
>  create mode 100644 lib/livepatch/test_klp_convert_mod_b.c
>  create mode 100644 lib/livepatch/test_klp_convert_mod_c.c
>  create mode 100644 lib/livepatch/test_klp_convert_sections.c
>  create mode 100644 samples/livepatch/livepatch-annotated-sample.c
>  create mode 100644 scripts/livepatch/.gitignore
>  create mode 100644 scripts/livepatch/Makefile
>  create mode 100644 scripts/livepatch/elf.c
>  create mode 100644 scripts/livepatch/elf.h
>  create mode 100644 scripts/livepatch/klp-convert.c
>  create mode 100644 scripts/livepatch/klp-convert.h
>  create mode 100644 scripts/livepatch/list.h
> 
> -- 
> 2.26.3
> 
