Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FE475BBB4
	for <lists+live-patching@lfdr.de>; Fri, 21 Jul 2023 03:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjGUBJl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jul 2023 21:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjGUBJk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jul 2023 21:09:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D70E75;
        Thu, 20 Jul 2023 18:09:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1DB961CE4;
        Fri, 21 Jul 2023 01:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BB8C433C7;
        Fri, 21 Jul 2023 01:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689901778;
        bh=/8oyoPLz85rY3rKdG/0bkXtNnDYYoJy6cS+Fc2EF9Fw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H1Kcc4cJl9ZNDC42pfT4pgfkH2WYKNP1xitzz4/h5+gbRWOhoQynLo8x1u2tlO/tn
         FZRgLoMturKh3QCcc8kZTx8coFNYt/YnwjbvBkTTGNTfduhOdII0UFFCxh0xBbDcmf
         VOjT/u4hHlCfHaqFZZaKuTWaEEq7hQYtY+rfyGV/qHYnDEJXy/b4oCzb/0/z04JKzU
         XtLkAgAM3BfHTe/lq1l7BZqmjs+bWot8N8duO19kwCvHxfZNvglciSHDt7xg7n4EC+
         K+T0mMDEIalbW+15M16oPMIix20N3QsRCxfayJUsyzOzo64nJ67ozdttsUpnXkN3i3
         pVqX0XGXjFbIA==
Date:   Fri, 21 Jul 2023 10:09:31 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Nick Alcock <nick.alcock@oracle.com>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alessandro Carminati <alessandro.carminati@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <eugene.loh@oracle.com>,
        <kris.van.hees@oracle.com>, <live-patching@vger.kernel.org>
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Message-Id: <20230721100931.b366ecfbeb09cba01c73d47a@kernel.org>
In-Reply-To: <87wmyu7n5t.fsf@esperi.org.uk>
References: <ZLVxUQiC5iF+xTPQ@bombadil.infradead.org>
        <20230714150326.1152359-1-alessandro.carminati@gmail.com>
        <20230717105240.3d986331@gandalf.local.home>
        <874jm088ah.fsf@esperi.org.uk>
        <6edbfe7b-aec4-2b3c-2f85-42e418ab3d99@intel.com>
        <87wmyu7n5t.fsf@esperi.org.uk>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 20 Jul 2023 14:00:46 +0100
Nick Alcock <nick.alcock@oracle.com> wrote:

> On 19 Jul 2023, Alexander Lobakin verbalised:
> 
> > From: Nick Alcock <nick.alcock@oracle.com>
> > Date: Wed, 19 Jul 2023 12:12:06 +0100
> >>> Yes, please coordinate with Nick and review each other's work, now we
> >>> have two separate efforts with different reasons but hopefully we'll
> >
> > Three efforts[0] :D Mine went unnoticed unfortunately, so I switched to
> > other projects then.
> 
> It's odd, nobody seems to have noticed these until recently and now
> suddenly people are crawling out of the woodwork wanting unique
> addresses :) maybe the ambiguous ones are just getting commonplace
> enough that they're biting people more often?

Usually, the ambiguous symbols are used as internal functions and
are easily changed by kernel update. Thus it is only used for debugging.
On the other hand, exposed symbols are considered as more stable (It's
not really that stable.) so users tend to use that.

BTW, note that `perf probe` and kprobe-events already supported that by
'_text+OFFSET' style to point those functions (`perf probe` convert the
given 'function@file-path' place to '_text+OFFSET' using DWARF and ELF).
BPF doesn't because it only supports "function name". (I'm not sure how
Dtrace support it)

If we really consider to improve BPF trace to trace such internal functions,
I think you should consider to reuse perf-probe's code to find actual
address and convert it to '_text+OFFSET' style to specify the probe point.

I think this still useful if user can identify the traced symbol from the
source code line, easily without DWARF analysis. And BPF also need to
support "SYMBOL+OFFSET" style probe points.

> 
> > My idea was to give relative path from the kernel root to the objfile,
> > as we have a good bunch of non-unique "filename + symbol name" pairs.
> 
> I considered that, but unfortunately that has two problems to a raging
> perfectionist like me:
> 
>  - the objfile probably won't exist except if you're actually doing
>    kernel development, since kernel build trees are big enough that a
>    lot of people delete them after building or ship kernels to other
>    machines: if someone else built your kernel (overwhelmingly common
>    among non-kernel-devs) the objfiles are sure to be absent. (But an
>    option to not truncate the names when you know they won't be absent
>    might be a good idea, though this pushes space requirements up by
>    hundreds of kilobytes so it should probably be off by default.)

As I said, these internal symbol tracing is usually only for debugging
the kernel. So I think this is not so problematic.

Thank you,

> 
>  - even giving a path to the kernel module on disk (much lower
>    resolution and vulnerable to ambiguity again) is unreliable because
>    there's absolutely no guarantee that any given process can see any of
>    them: they might be in a different fs namespace or the modules might
>    only be present in an initramfs (hell, I even know setups which
>    *compile* the modules needed for rootfs mounting in the initramfs!
>    Yes this is borderline insane, yes it happens). More commonly, they
>    might be compressed using any of a number of compressors, changing
>    the name, and the kernel has no idea which compressor might have been
>    used (not unless you want it to go and look, and, well, wandering
>    around over the fs hunting down .ko.* files from kernelspace to get
>    their names right is *not* my idea of a good time! It's hard enough
>    to get that right from userspace, honestly, even with kmod helping.)
> 
>    The most you could do would be to provide a key you could use with
>    kmod to dig the real modules out from userspace. Partial names are as
>    good as anything for that :)
> 
> So all the objfile names are, when it comes down to it, is names with no
> intrinsic meaning: even if they're filenames of some kind, tools can't
> rely on being able to access those files. (For my most common use case,
> using a tracer on an enterprise-built production kernel, they'd almost
> never be able to.)
> 
> So you might as well treat the objfile names as arbitrary string keys
> that might be a memory-jogger for humans, which means you can chop
> boring bits off them to save space :)


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
