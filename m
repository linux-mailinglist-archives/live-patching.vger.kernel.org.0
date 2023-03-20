Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15E26C2258
	for <lists+live-patching@lfdr.de>; Mon, 20 Mar 2023 21:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbjCTUPt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Mar 2023 16:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjCTUPs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Mar 2023 16:15:48 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505E631BF1;
        Mon, 20 Mar 2023 13:15:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CE96721A6E;
        Mon, 20 Mar 2023 20:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679343344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yfhoh6STg6AVEEoCjwNPK3xLyEiz12Sut2kHWBVe9sQ=;
        b=i6IuJk/Pkh6mzgjKZlO7nUXAZjsUSIkLOdqUT/4Nq1X5rHi8j0BRlE01gYhiH3Os5trkJY
        lp0j7Lpe/1CXjWceqRdFpo603DW4Ha/mTfpAj9+eMMkRjpd/n1+zke0rDCKdSyqkbMuoLd
        apoMRiNi9FDL+hdMzM5JPoR8BtnRWfU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679343344;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yfhoh6STg6AVEEoCjwNPK3xLyEiz12Sut2kHWBVe9sQ=;
        b=xlLjOo3LsFqnCjGZt1lgdj5AjBHyMpq7sE3dIkGfT09zh05eGN+R+Pl2VpeQKLwqW0J2ZO
        1zJoLHCVyIOrgxAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 57F0513416;
        Mon, 20 Mar 2023 20:15:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id b01/CPC+GGS9WgAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Mon, 20 Mar 2023 20:15:44 +0000
Date:   Mon, 20 Mar 2023 17:15:41 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
Message-ID: <20230320201541.2f6mchhogr3e4yrs@daedalus>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230314202356.kal22jracaw5442y@daedalus>
 <ZBTNvEPrCcRj3F1C@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBTNvEPrCcRj3F1C@redhat.com>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Mar 17, 2023 at 04:29:48PM -0400, Joe Lawrence wrote:
> On Tue, Mar 14, 2023 at 05:23:56PM -0300, Marcos Paulo de Souza wrote:
> > On Mon, Mar 06, 2023 at 09:08:14AM -0500, Joe Lawrence wrote:
> > > Summary
> > > -------
> > > 
> > > Livepatches may use symbols which are not contained in its own scope,
> > > and, because of that, may end up compiled with relocations that will
> > > only be resolved during module load. Yet, when the referenced symbols
> > > are not exported, solving this relocation requires information on the
> > > object that holds the symbol (either vmlinux or modules) and its
> > > position inside the object, as an object may contain multiple symbols
> > > with the same name.  Providing such information must be done accordingly
> > > to what is specified in Documentation/livepatch/module-elf-format.txt.
> > > 
> > > Currently, there is no trivial way to embed the required information as
> > > requested in the final livepatch elf object. klp-convert solves this
> > > problem in two different forms: (i) by relying on a symbol map, which is
> > > built during kernel compilation, to automatically infer the relocation
> > > targeted symbol, and, when such inference is not possible (ii) by using
> > > annotations in the elf object to convert the relocation accordingly to
> > > the specification, enabling it to be handled by the livepatch loader.
> > > 
> > > Given the above, add support for symbol mapping in the form of a
> > > symbols.klp file; add klp-convert tool; integrate klp-convert tool into
> > > kbuild; make livepatch modules discernible during kernel compilation
> > > pipeline; add data-structure and macros to enable users to annotate
> > > livepatch source code; make modpost stage compatible with livepatches;
> > > update livepatch-sample and update documentation.
> > > 
> > > The patch was tested under three use-cases:
> > > 
> > > use-case 1: There is a relocation in the lp that can be automatically
> > > resolved by klp-convert.  For example. see the saved_command_line
> > > variable in lib/livepatch/test_klp_convert2.c.
> > > 
> > > use-case 2: There is a relocation in the lp that cannot be automatically
> > > resolved, as the name of the respective symbol appears in multiple
> > > objects. The livepatch contains an annotation to enable a correct
> > > relocation.  See the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections
> > > in lib/livepatch/test_klp_convert{1,2}.c.
> > > 
> > > use-case 3: There is a relocation in the lp that cannot be automatically
> > > resolved similarly as 2, but no annotation was provided in the
> > > livepatch, triggering an error during compilation.  Reproducible by
> > > removing the KLP_MODULE_RELOC / KLP_SYMPOS annotation sections in
> > > lib/livepatch/test_klp_convert{1,2}.c.
> > > 
> > > Selftests have been added to exercise these klp-convert use-cases
> > > through several tests.
> > > 
> > > 
> > > Testing
> > > -------
> > > 
> > > The patchset selftests build and execute on x86_64, s390x, and ppc64le
> > > for both default config (with added livepatch dependencies) and a larger
> > > RHEL-9-ish config.
> > > 
> > > Using the Intel's Linux Kernel Performance tests's make.cross,
> > > klp-convert builds and processes livepatch .ko's for x86_64 ppc64le
> > > ppc32 s390 arm64 arches.
> > > 
> > > 
> > > Summary of changes in v7
> > > ------------------------
> > > 
> > > - rebase for v6.2
> > > - combine ("livepatch: Add klp-convert tool") with ("livepatch: Add
> > >   klp-convert annotation helpers")
> > > - combine ("kbuild: Support for symbols.klp creation") with ("modpost:
> > >   Integrate klp-convert") to simplify Kbuild magic [Petr, Nicolas]
> > > - klp-convert: add safe_snprintf() (-Wsign-compare)
> > > - klp-convert: fix -Wsign-compare warnings
> > > - klp-convert: use calloc() where appropriate
> > > - klp-convert: copy ELF e_flags
> > > - selftests: fix various build warnings
> > > - klp-convert: WARN msg simplification, failed sanity checks, and sympos
> > >   comment [Marcos]
> > > - klp-convert: fix elf_write_file() error paths [Petr]
> > 
> > Thanks for the new version Joe. I've run the ksefltests on my x86 laptop, and it
> > succeed as expected, so
> > 
> > Tested-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > 
> 
> Thanks for the testing and reviews, Marcos.
> 
> The selftests are the first level of testing... we should probably
> tackle a real or simulated CVE fix to see how well the tooling fits
> larger livepatches.

Our plan is to start testing new livepatches with klp-convert to ensure that it
works as expected, removing the need of kallsyms_lookup. Let's see how it goes
in the next few weeks.

> 
> One complication that I can envision is symbol positioning.  Currently,
> the klp-convert annotations are a direct mirror of the kernel's
> <obj,symbol,pos> tuple.  It should be possible to make this a bit more
> user friendly for the livepatch developer if the annotations were
> <obj,file,symbol>, as derived from the vmlinux / module.tmp.ko symbol
> tables.
> 
> For example, the following code:
> 
>   KLP_MODULE_RELOC(test_klp_convert_mod, test_klp_convert_mod_b.c) test_klp_convert_mod_relocs_b[] = {
>         KLP_SYMPOS(homonym_string),
>         KLP_SYMPOS(get_homonym_string),
>   };
> 
> could generate the following relocations:
> 
>   Relocation section '.rela.klp.module_relocs.test_klp_convert_mod.test_klp_convert_mod_b.c' at offset 0x1dc0 contains 2 entries:
>       Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
>   0000000000000000  0000003f00000001 R_X86_64_64            0000000000000000 homonym_string + 0
>   0000000000000008  0000004900000001 R_X86_64_64            0000000000000000 get_homonym_string + 0
> 
> for which klp-convert looks up in symbols.klp:
> 
>   klp-convert-symbol-data.0.2
>   *vmlinux
>   ...
>   *test_klp_convert_mod
>   -test_klp_convert_mod_a.c             << added filenames to the format
>   test_klp_get_driver_name
>   driver_name
>   get_homonym_string                    << sympos = 1
>   homonym_string                        << sympos = 1
>   ...
>   -test_klp_convert_mod_b.c
>   get_homonym_string                    << sympos = 2
>   homonym_string                        << sympos = 2
>   ...
> 
> and then generates the usual klp-relocations as currently defined.

This can get verbose very quickly, but I liked the idea. The sympos is much more
cryptic than specifying the file where the symbol lives on.

> 
> (Unfortunately full pathnames are not saved in the STT_FILE symbol table
> entries, so there will be a few non-unique <obj,file,symbol> entries.  I
> believe the last time this was discussed, we found that there were a
> relatively small number of such symbols.)
> 
> Have you tried retrofitting klp-convert into any real-world livepatch?
> I'm curious as to your observations on the overall experience, or
> thoughts on the sympos annotation style noted above.

As I mentioned I'll start using klp-convert with new livepaches for testing
purposes in the next coming weeks. I'll reply in a few weeks about the
experience so far.

> 
> Regards,
> 
> -- Joe
> 
