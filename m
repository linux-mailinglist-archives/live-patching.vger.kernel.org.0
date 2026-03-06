Return-Path: <live-patching+bounces-2154-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +ISLED0/q2lnbgEAu9opvQ
	(envelope-from <live-patching+bounces-2154-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 21:55:25 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F7EA227A62
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 21:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 45F953049951
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 20:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8911A481655;
	Fri,  6 Mar 2026 20:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YgeOFeQZ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EEC371D13;
	Fri,  6 Mar 2026 20:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772830502; cv=none; b=qG08z52JQJ6sQQa1qpnclLsmL+Ug8VH+SDrb/rDU2crup/m92O4jSokZqENkdckxTonwiNUSyfJrBKoVtnuTyART3b9UknxSFsi2ViiGvSH5IzsBopXpnyJ00v5gQmnRhdhehljCp1eMxuWuweQiFIM6PdGl6vX2TFKhv2I7oCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772830502; c=relaxed/simple;
	bh=lwUlwWn1p4U0CvKcROpGVeAA5eYZynhYatIqIuO3OYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpEZNC1UgjVyj9btyu1Cfmk79n/0WLzEdu+aqVS9cqnn1ZvwEFjryq2ZgHQe/P++Wtm8SodaP4iTyqXKQisjoSlzCnVlLjb/x5snm0dT+SgNuWYRqFYFe3FzyZWV0rMXzNmItua8sbos4M0yP6Tf4LRxRpzpAnpNM946Y8rtkEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YgeOFeQZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFCEC4CEF7;
	Fri,  6 Mar 2026 20:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772830502;
	bh=lwUlwWn1p4U0CvKcROpGVeAA5eYZynhYatIqIuO3OYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YgeOFeQZXbOJv6dZuNmEo66c9DJCmjzqB0Ze9CxkE4J9Tkk/VuJpIfBjoJp2WSkPp
	 hRCkXUlL+dTfzhxYFIVZ0usjcoYCrYRBjb9N+bzVUHzIy/tJpDbR9cMFFEnZv5zw+h
	 JKMlYzIzWYZlWdMogD1FuEBxrSsQZg3OwOP4vsSpoPP3goXaQlnxGE32oiI1UPPuJq
	 gh8+vXj11eekdVnVHHSD/MzVv20fmc70SBPmK+poRZwQOhd9/H6da7Z2ihpPbgRIlx
	 PnL7ZFO4haiJW0BQ/bs/PnQA384rmZS6oFdXFjFpLt23Fprk+j+66i2F+4ht8fsPax
	 yaWFPgOScQDrw==
Date: Fri, 6 Mar 2026 12:54:59 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
Cc: linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org, 
	kernel-team@fb.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Song Liu <song@kernel.org>
Subject: Re: [PATCH kbuild] kbuild: Allow to reduce the number of suffixes
 for clang thin-lto build
Message-ID: <bt7t2452h27o7bf27f7ljs2xhn7venhvslynq3a77jbtwi7hqk@cgobhbhi5y2r>
References: <20260306034325.3605301-1-yonghong.song@linux.dev>
 <pat2b5nibiik6nua6ls7cu7eqy5qgrugo4gnel32bz6vpcrmz3@f7ynsbvnxcaj>
 <f1afe1e8-0dfd-47b0-8ca4-f09d4fda13eb@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f1afe1e8-0dfd-47b0-8ca4-f09d4fda13eb@linux.dev>
X-Rspamd-Queue-Id: 7F7EA227A62
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2154-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.947];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[llvm.org:url,linux.dev:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 11:40:21AM -0800, Yonghong Song wrote:
> 
> 
> On 3/6/26 10:32 AM, Josh Poimboeuf wrote:
> > On Thu, Mar 05, 2026 at 07:43:25PM -0800, Yonghong Song wrote:
> > > The current clang thin-lto build often produces lots of symbols with
> > > suffix. The following is a partial list of such function call symbols:
> > >      ...
> > >      ethnl_module_fw_flash_ntf.llvm.7631589765585346066
> > >      __nf_conntrack_alloc.llvm.6438426151906658917
> > >      tcp_can_early_drop.llvm.11937612064648250727
> > >      tcp_print_conntrack.llvm.11937612064648250727
> > >      ...
> > > 
> > > In my particular build with current bpf-next, the number of '*.llvm.<hash>'
> > > function calls is 1212. Such symbols make kernel live patching
> > > difficult since
> > >    - a minor code change will change the hash and then the '*.llvm.<hash>'
> > >      symbol becomes another one with a different hash or no hash, and
> > >    - a previous source-level symbol may become an one with suffix after live
> > >      patching code.
> > > 
> > > In [1], Song Liu suggested to reduce the number of '*.llvm.<hash>' functions
> > > to make live patch easier. In respond of this, I implemented this
> > > in llvm ([2]). The same thin-lto build with [2] only has two symbols with
> > > suffix:
> > >      m_stop.llvm.14460341347352036579
> > >      m_next.llvm.14460341347352036579
> > > This should make live patch much easier.
> > > 
> > > To support suffix symbol reduction, a new config
> > >      LTO_CLANG_THIN_SUFFIX_REDUCTION
> > > is introduced and the config depends on thin-lto and llvm23 or higher.
> > > 
> > > Two lld flags are necessary to enable this feature in kernel:
> > >      - Flag '--lto-whole-program-visibility' is needed as it ensures that all
> > >        modules are available in the same process, which is true for kernel at
> > >        thin-lto lld.
> > >      - Flag '-mllvm -always-rename-promoted-locals=false' is needed to enable
> > >        suffix reduction. Currently in llvm [1], only process mode is supported.
> > >        There is another distributed mode (across different processes or even
> > >        different machines) which is not supported yet ([2]).
> > > 
> > >    [1] https://lpc.events/event/19/contributions/2212
> > >    [2] https://github.com/llvm/llvm-project/pull/178587
> > > 
> > > Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
> > > ---
> > >   Makefile     |  3 +++
> > >   arch/Kconfig | 15 +++++++++++++++
> > >   2 files changed, 18 insertions(+)
> > > 
> > > diff --git a/Makefile b/Makefile
> > > index e944c6e71e81..9d6033595615 100644
> > > --- a/Makefile
> > > +++ b/Makefile
> > > @@ -1034,6 +1034,9 @@ endif
> > >   ifdef CONFIG_LTO_CLANG
> > >   ifdef CONFIG_LTO_CLANG_THIN
> > >   CC_FLAGS_LTO	:= -flto=thin -fsplit-lto-unit
> > > +ifdef CONFIG_LTO_CLANG_THIN_SUFFIX_REDUCTION
> > > +KBUILD_LDFLAGS += --lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false
> > > +endif
> > >   else
> > >   CC_FLAGS_LTO	:= -flto
> > >   endif
> > > diff --git a/arch/Kconfig b/arch/Kconfig
> > > index 102ddbd4298e..e1db64a3284e 100644
> > > --- a/arch/Kconfig
> > > +++ b/arch/Kconfig
> > > @@ -861,8 +861,23 @@ config LTO_CLANG_THIN
> > >   	    https://clang.llvm.org/docs/ThinLTO.html
> > >   	  If unsure, say Y.
> > > +
> > >   endchoice
> > > +config LTO_CLANG_THIN_SUFFIX_REDUCTION
> > > +	bool "Clang ThinLTO Suffix Reduction (EXPERIMENTAL)"
> > > +	depends on LTO_CLANG_THIN
> > > +	depends on CLANG_VERSION >= 230000
> > > +	default y
> > > +	help
> > > +	  This option allows to reduce the number of symbols with
> > > +	  '.llvm.<hash' suffixes. This can help KLP (kernel living
> > > +	  patch) as symbol name can stay stable in most cases.
> > > +
> > > +	  See https://github.com/llvm/llvm-project/pull/178587
> > > +
> > > +	  If unsure, say N.
> > > +
> > Thanks!  Would there be any downsides to enabling this feature
> > unconditionally in the kernel when the compiler supports it?
> 
> The only downside is for the following case:
> 
> C   file: static function foo()
> Asm file: global function foo()
> 
> The thin-lto will collect all C files and with the above llvm patch,
> the static function foo() may be promoted to global function foo()
> if there is no other pre-existing global function foo() in all C files.
> 
> In such cases, there will be a conflict since
> there are two global function foo() (one from C file, another from Asm file).
> In such cases, the build will fail.
> 
> How do you think we could hit such issues in linux kernel?
> Maybe should have default no for the new config?
> 
> I think the chance should be very low. The following is a grab for x86
> for global symbols in asm code:
> 
> [~/work/others/linux/arch/x86 (master)]$ egrep -r globl

There are actually quite a bit more than that, see SYM_CODE_START:

  $ git grep 'SYM_CODE_START(' |wc -l
  169

But still, I agree the chance of a conflict would be very low.  And
global assembly functions tend to be rather uniquely named.

> Maybe we could collect all global symbols in asm codes before lld,
> and then we add an option in lld to feed those global symbols (with a file?),
> then we can be sure there won't be any conflict?

That wouldn't be worth the effort in my opinion.

I think we should just unconditionally enable
-always-rename-promoted-locals=false when it's available.  While that
will implicitly enforce that global asm functions be uniquely named
across the tree, I don't see that as a problem.  In the rare case of a
conflict, we can just rename the function.

-- 
Josh

