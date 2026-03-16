Return-Path: <live-patching+bounces-2208-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPVeFhHct2mcWAEAu9opvQ
	(envelope-from <live-patching+bounces-2208-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 11:31:45 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4EC0297F25
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 11:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9FD783044B58
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2026 10:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B2D38F63B;
	Mon, 16 Mar 2026 10:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+47v3iI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACF838F24A;
	Mon, 16 Mar 2026 10:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773656976; cv=none; b=LAdIBxIFqbxeB54plh9V1J5pUmYMUeS4P08oRbZPYvZsuAVo6PR2McSX/yrtwlvOIMaVGeZ7+epGuq3A2UgoSy0ZNPEJHYFoZaix2hCfeYaKGkWg97B9lDKoJy4wA0zJQnHZM1Z0sELU4d52QsGHLEoBCCcpR6YASDFItDL3JqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773656976; c=relaxed/simple;
	bh=aEX4QN5c8CL9OE1RZp1PM5q0rNqVRA4KwIpl/cQoysE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rPoGhiZvVbcsITC9UBQonbWRKnYwWkZ2z7nVLA1rXBroVnClqkBlhhNk0R6fnNfkFnXSEh8r0TLz6CL5CE7Ct1DaAvIu6lXsSU9njhaALiB1rULA1KIvhuhlh690B8r4kzqZFOBcH6ala4zquLSBaNTlOFprNrdvBixGDrRTSo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+47v3iI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A96DC19421;
	Mon, 16 Mar 2026 10:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773656976;
	bh=aEX4QN5c8CL9OE1RZp1PM5q0rNqVRA4KwIpl/cQoysE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y+47v3iI+4kvn42T2jWbqKBDm43CcCm6M3z5QDiSOmlTsamspBVtd3yX2bACVWUu4
	 /Yuwg2ImBDxJ+tEegQfsKt4mXCi21MBaF8MBRYPQ/thEBI6vB2o7UWp2q5iA3A4S1/
	 934sREUs6YqhCclcetk/rVDltko00dxm4TehNayHbw12QEs4JZA2DGlS/PQ6foSDOT
	 gZHWLC3bog7hy/78OrhGuznn9DasnzOnVM+CrIKKq7Ptj18LlHbp6pfXq/M+En9ZWg
	 MhGM8I3cu40pLVyGg3Ed/XI019FTfL8QlYtmdiWMDaNgUd2i6ttLzX16rR8xNmzvJi
	 uF8cViMdYxzRQ==
Date: Mon, 16 Mar 2026 08:07:29 +0100
From: Nicolas Schier <nsc@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
Cc: linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@kernel.org>, kernel-team@fb.com,
	Nathan Chancellor <nathan@kernel.org>, Song Liu <song@kernel.org>
Subject: Re: [PATCH kbuild v2] kbuild: Reduce the number of
 compiler-generated suffixes for clang thin-lto build
Message-ID: <abesMbRN2PFkobxY@levanger>
Mail-Followup-To: Nicolas Schier <nsc@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@kernel.org>, kernel-team@fb.com,
	Nathan Chancellor <nathan@kernel.org>, Song Liu <song@kernel.org>
References: <20260307050250.3767489-1-yonghong.song@linux.dev>
 <177332462174.82802.2344537821152391518.b4-ty@kernel.org>
 <044bebc0-d996-4be3-9330-a64195c19a84@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <044bebc0-d996-4be3-9330-a64195c19a84@linux.dev>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2208-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nsc@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4EC0297F25
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, Mar 15, 2026 at 09:37:22AM -0700, Yonghong Song wrote:
> 
> 
> On 3/12/26 7:12 AM, Nicolas Schier wrote:
> > On Fri, 06 Mar 2026 21:02:50 -0800, Yonghong Song wrote:
> > > The current clang thin-lto build often produces lots of symbols with
> > > suffix. The following is a partial list of such function call symbols:
> > >      ...
> > >      ethnl_module_fw_flash_ntf.llvm.7631589765585346066
> > >      __nf_conntrack_alloc.llvm.6438426151906658917
> > >      tcp_can_early_drop.llvm.11937612064648250727
> > >      tcp_print_conntrack.llvm.11937612064648250727
> > >      ...
> > > 
> > > [...]
> > Note: Due to application of [1] to kbuild-next-unstable, I had to update the
> >        patch context.
> > 
> > [1]: https://lore.kernel.org/linux-kbuild/20251028182822.3210436-1-xur@google.com/
> > 
> > 
> > 
> > Applied to kbuild/kbuild-next.git (kbuild-next-unstable), thanks!
> > 
> > [1/1] kbuild: Reduce the number of compiler-generated suffixes for clang thin-lto build
> >        https://git.kernel.org/kbuild/c/b7a7ce34
> > 
> > Please look out for regression or issue reports or other follow up
> > comments, as they may result in the patch/series getting dropped,
> > reverted or modified (e.g. trailers). Patches applied to the
> > kbuild-next-unstable branch are accepted pending wider testing in
> > linux-next and any post-commit review; they will generally be moved
> > to the kbuild-next branch in about a week if no issues are found.
> 
> Thanks, Nicolas,
> 
> I looked at the patch [1] and find that my patch needs some change.
> The current change is
> 
> @@ -1047,6 +1047,7 @@ CC_FLAGS_LTO := -flto
> else
> CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit
> +KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility -mllvm
> -always-rename-promoted-locals=false)
> endif
> CC_FLAGS_LTO += -fvisibility=hidden Due to [1], the above change should be
> @@ -1047,6 +1047,7 @@ CC_FLAGS_LTO := -flto
> else
> CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit
> +if CONFIG_LTO_CLANG_THIN
> +KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility -mllvm
> -always-rename-promoted-locals=false)
> +endif
> endif
> CC_FLAGS_LTO += -fvisibility=hidden
> 
> The reason likes below:
> 
> The patch [1] introduced CONFOG_LTO_CLANG_THIN_DIST and in Makefile, for the following change:
> 
>  ifdef CONFIG_LTO_CLANG
> -ifdef CONFIG_LTO_CLANG_THIN -CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit
> -else +ifdef CONFIG_LTO_CLANG_FULL  CC_FLAGS_LTO	:= -flto
> +else +CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit  endif
>  CC_FLAGS_LTO	+= -fvisibility=hidden
> 
> The else branch 'CC_FLAGS_LTO := -flto=thin -fsplit-lto-unit' will support both CONFIG_LTO_CLANG_THIN and CONFIG_LTO_CLANG_THIN_DIST.
> 
> My patch commit message mentioned that the new flag won't support
> thinlto distributed mode yet. So The new ldflags
>   $(call ld-option,--lto-whole-program-visibility -mllvm
> -always-rename-promoted-locals=false) needs under LTO_CLANG_THIN but not
> LTO_CLANG_THIN_DIST. There will be some effort in llvm to support
> distributed thin-lto as well for suffix reduction. But it may take a little
> bit time as llvm needs some infrastructure change before supporting
> distributed thin-lto. Thanks!

Thanks a lot!  I changed the commit as instructed:

$ git range-diff b7a7ce345daa...6a76b3c06a1d
1:  b7a7ce345daa ! 1:  6a76b3c06a1d kbuild: Reduce the number of compiler-generated suffixes for clang thin-lto build
    @@ Makefile: ifdef CONFIG_LTO_CLANG_FULL
      CC_FLAGS_LTO      := -flto
      else
      CC_FLAGS_LTO      := -flto=thin -fsplit-lto-unit
    ++if CONFIG_LTO_CLANG_THIN
     +KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false)
    ++endif
      endif
      CC_FLAGS_LTO      += -fvisibility=hidden


and it is pushed to kbuild/kbuild-next-unstable
https://git.kernel.org/kbuild/c/6a76b3c06a1d359a3e84c37bc0fead370f6ccfc0


-- 
Nicolas

