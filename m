Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4DB73A1EF
	for <lists+live-patching@lfdr.de>; Thu, 22 Jun 2023 15:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjFVNgF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 22 Jun 2023 09:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjFVNgD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 22 Jun 2023 09:36:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4741BF7
        for <live-patching@vger.kernel.org>; Thu, 22 Jun 2023 06:36:01 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A64E71FDEC;
        Thu, 22 Jun 2023 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1687440960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bnHoz7BCE2jC8GiYCZboutsEsGdiJ0fm30cJzVN5Au0=;
        b=qiQ1YxDRwTly8bSWnOcZewX529XTqi/kHO51zMbZ//3S0BSCx2FTDk8P2WuG273UBWlK6o
        U/u49YZSH2KXlBPhotx37xgQVvUkEQ1uZQuuu9OTrqIGgPrSj+2KpGoe/GsQ9nJyZuIjnS
        Grx3ppKYU3PWhXoMzoMVLuEBljtUsm8=
Received: from suse.cz (pmladek.udp.ovpn2.prg.suse.de [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0ABAE2C141;
        Thu, 22 Jun 2023 13:35:59 +0000 (UTC)
Date:   Thu, 22 Jun 2023 15:35:56 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Yonghong Song <yhs@meta.com>
Cc:     Song Liu <songliubraving@meta.com>, Song Liu <song@kernel.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "KE.LI" <like1@oppo.com>,
        Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match
 symbols exactly
Message-ID: <ZJROPO1ukwMyYFnm@alley>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
 <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
 <ZJA8yohmmf6fKsJQ@alley>
 <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
 <ZJK5tiO3wXHiBeBh@alley>
 <E47B9D18-299C-4F95-B4F6-24DB6A54A79F@fb.com>
 <6df9b18c-d152-942a-b618-bb8417c7b8cd@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6df9b18c-d152-942a-b618-bb8417c7b8cd@meta.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

I have added people mentioned in commits which modified
cleanup_symbol_name() in kallsyms.c.

I think that stripping ".*" suffix does not work for static
variables defined locally from symbol does always work,
see below.



On Wed 2023-06-21 15:34:27, Yonghong Song wrote:
> On 6/21/23 12:18 PM, Song Liu wrote:
> > > On Jun 21, 2023, at 1:52 AM, Petr Mladek <pmladek@suse.com> wrote:
> > > On Tue 2023-06-20 22:36:14, Song Liu wrote:
> > > > > On Jun 19, 2023, at 4:32 AM, Petr Mladek <pmladek@suse.com> wrote:
> > > > > On Sun 2023-06-18 22:05:19, Song Liu wrote:
> > > > > > On Sun, Jun 18, 2023 at 8:32 PM Leizhen (ThunderTown)
> > > > > > <thunder.leizhen@huawei.com> wrote:
> > > > I am not quite following the direction here. Do we need more
> > > > work for this patch?
> > > 
> > > Good question. I primary tried to add more details so that
> > > we better understand the problem.
> > > 
> > > Honestly, I do not know the answer. I am neither familiar with
> > > kpatch nor with clang.

> > This is pretty complicated.
> > 
> > 1. clang with LTO does not use the suffix to eliminated duplicated
> > kallsyms, so old_sympos is still needed. Here is an example:
> > 
> > # grep init_once /proc/kallsyms
> > ffffffff8120ba80 t init_once.llvm.14172910296636650566
> > ffffffff8120ba90 t inode_init_once
> > ffffffff813ea5d0 t bpf_user_rnd_init_once
> > ffffffff813fd5b0 t init_once.llvm.17912494158778303782
> > ffffffff813ffbf0 t init_once
> > ffffffff813ffc60 t init_once
> > ffffffff813ffc70 t init_once
> > ffffffff813ffcd0 t init_once
> > ffffffff813ffce0 t init_once
> > 
> > There are two "init_once" with suffix, but there are also ones
> > without them.
> 
> This is correct. At LTO mode, when a static function/variable
> is promoted to the global. The '.llvm.<hash>' is added to the
> static function/variable name to form a global function name.
> The '<hash>' here is computed based on IR of the compiled file
> before LTO. So if one file is not modified, then <hash>
> won't change after additional code change in other files.

OK, so the ".llvm.<hash>" suffix is added when a symbol is promoted
from static to global. Right?

> > 2. kpatch-build does "Building original source", "Building patched
> > source", and then do binary diff of the two. From our experiments,
> > the suffix doesn't change between the two builds. However, we need
> > to match the build environment (path of kernel source, etc.) to
> > make sure suffix from kpatch matches the kernel.
>
> The goal here is to generate the same IR (hence <hash>) if
> file content is not changed. This way, <hash> value will
> change only for those changed files.

Hmm, how does kpatch match the fixed functions? They are modified
so that they should get different IR (hash). Or do I miss
anything, please?

> > 3. The goal of this patch is NOT to resolve different suffix by
> > llvm (.llvm.[0-9]+). Instead, we are trying fix issues like:
> > 
> > #  grep bpf_verifier_vlog /proc/kallsyms
> > ffffffff81549f60 t bpf_verifier_vlog
> > ffffffff8268b430 d bpf_verifier_vlog._entry
> > ffffffff8282a958 d bpf_verifier_vlog._entry_ptr
> > ffffffff82e12a1f d bpf_verifier_vlog.__already_done

And <function>.<symbol> notation seems to be used for static symbols
defined inside a function.

I guess that it is used when the symbols stay statics. It would
probably get additional ".llvm.<hash>" when it got promoted
from static to global. But this probably never happens.

Do I get it correctly?

It means that we have two different types of name changes:

  1. .llvm.<hash> suffix

     If we remove this suffix then we will not longer distinguish
     symbols which stayed static and which were promoted to global
     ones.

     The result should be basically the same as without LTO.
     Some symbols might have duplicated name. But most symbols
     would have an unique one.


  2. <function>.<symbol> name

     In this case, <symbol> is _not_ suffix. It is actually
     the original symbol name.

     The extra thing is the <function>. prefix.

     These static variables seem to have special handling even
     with gcc without LTO. gcc adds an extra id instead,
     for example:

	$> nm vmlinux | grep " _entry_ptr" | head
	ffffffff82a2e800 d _entry_ptr.100135
	ffffffff82a2e7f8 d _entry_ptr.100178
	ffffffff82a32e70 d _entry_ptr.100798
	ffffffff82a1e240 d _entry_ptr.10342
	ffffffff82a33930 d _entry_ptr.104764
	ffffffff82a339c8 d _entry_ptr.104830
	ffffffff82a33928 d _entry_ptr.104871
	ffffffff82a33920 d _entry_ptr.104877
	ffffffff82a33918 d _entry_ptr.104893
	ffffffff82a339c0 d _entry_ptr.104905

	$> nm vmlinux | grep panic_console_dropped
	ffffffff853618e0 b panic_console_dropped.54158


Effect from the tracers POV?

  1. .llvm.<hash> suffix

     The names without the .llvm.<hash> suffix are the same as without
     LTO. This is probably why commit 8b8e6b5d3b013b0b ("kallsyms: strip
     ThinLTO hashes from static functions") worked. The tracers probably
     wanted to access only the symbols with uniqueue names


  2. <function>.<symbol> name

     The name without the .<symbol> suffix is the same as the function
     name. The result are duplicated function names.

     I do not understand why this was not a problem for tracers.
     Note that this is pretty common. _entry and _entry_ptr are
     added into any function calling printk().

     It seems to be working only by chance. Maybe, the tracers always
     take the first matched symbol. And the function name, without
     any suffix, is always the first one in the sorted list.


Effect from livepatching POV:

  1. .llvm.<hash> suffix

      Comparing the full symbol name looks fragile to me because
      the <hash> might change.

      IMHO, it would be better to compare the names without
      the .llvm.<hash> suffix even for livepatches.


   2. <function>.<symbol> name

      The removal of <.symbol> suffix is a bad idea. The livepatch
      code is not able to distinguish the symbol of the <function>
      and static variables defined in this function.

      IMHO, it would be better to compare the full
       <function>.<symbol> name.


Result:

IMHO, cleanup_symbol_name() should remove only .llwn.* suffix.
And it should be used for both tracers and livepatching.

Does this makes any sense?

Best Regards,
Petr
