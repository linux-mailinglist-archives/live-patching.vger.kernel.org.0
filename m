Return-Path: <live-patching+bounces-2052-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0EEgADGBl2kOzQIAu9opvQ
	(envelope-from <live-patching+bounces-2052-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:31:29 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FEC2162CF8
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 22:31:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1CEF83004D3B
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 21:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3812E973F;
	Thu, 19 Feb 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qUJZGIKz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682912773D8
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771536685; cv=none; b=tt2o6u4GxnMEVC8Gn+rQeFtjpHTuV9tn1jTVblxNOdjcQV8tsH7Bjn3PVfoND+ODpzq66tw0m+ESnOWV/dLH/cvsyushyn4E19j97OgQJ37OOp2MRlYtjkuYU1NBMrL7r8xcrCO3yLFonUWllqw8nj2dlUiIqwW1P+EIXMiiTF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771536685; c=relaxed/simple;
	bh=S9bIX+5W7VvwzSJKAKhXNMIFa7Yf5nvuYrhOqDyUS84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r8mCOl0g5NB++uzkVnMC+oPiYB9xJ8jeM5swHIZnXafegJAtHPx4Aj1nDSIBZuZvr7UzbE12KOdTRdAigbw9crgDoc5qYik1C7AF43A7uG6W/fPQb0EeVr1liid8tQmDLLxY1oiolRIJYDXM7Tr5P0Yq9xhB88QA81zKiXz6yyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qUJZGIKz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77ACC116D0
	for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 21:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771536684;
	bh=S9bIX+5W7VvwzSJKAKhXNMIFa7Yf5nvuYrhOqDyUS84=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qUJZGIKz2uTgJjKpI49WvCRIUvyHGBo+hZoWWRY7HhC/JFdIzhMLxhP/cYqQxkaUS
	 YDy5VzXAnUGt5UN5CGg/m5IVZ/EotqIhCBDqD3DuC/pVx35XbNiFU+9Tv7+MmVGPP3
	 AoMYaI1G0UpOtM7VvhaajKPM3RZVqw/UFanKv3nyVELBrwKm0rslmkI1HOpsfkS1aI
	 l68fB90vjzvsA3DbvOgCOEYVoCIfUXjdTGmQddpB5EiX3FuzdHVBb1P+ZRW3VZgA2S
	 L4NdoPzNASAYJAmrb9ByXrxljwMJLMmIwGUP6hQOZXHP2AyfJt/3qeBHThdy+iqUq0
	 CHYuSIvel0dVw==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8946e0884afso25224266d6.1
        for <live-patching@vger.kernel.org>; Thu, 19 Feb 2026 13:31:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXqG/U6sZlWglaSAgg65eqXJgL8BRdpYj7s0b7PhJ2VUeu3ezNBqNtpfBEziWr6aH+aAM7tijFRns8vbRDs@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0xRzpiGz2diebhSfUoyoAW3D7q1U83kQQtdFa3vyjWt6tWoS/
	vtblUR1KbSGPJSXNUANZbF2vAnTVuIxI4A6RGTte6gs9LH52wwGjhuFx5XrVYqSVHXk9VCZ2+JT
	JOu/NQWHvT3zF07Yx/QdUz124iW3RHdA=
X-Received: by 2002:a05:6214:242c:b0:894:6b9e:253e with SMTP id
 6a1803df08f44-897404b8296mr305129266d6.52.1771536683953; Thu, 19 Feb 2026
 13:31:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212192201.3593879-1-song@kernel.org> <aZZEjfxgLWTWODE7@redhat.com>
 <CAPhsuW7zHDxct5OByqDH+i3m5xbqBrrRtEJ4xV=AC6rgFgbq3g@mail.gmail.com> <5l3i26zkg7eoprhuyl7pdujrn2a4vyule423xqovnoea53tu3j@j4pbbgdy232c>
In-Reply-To: <5l3i26zkg7eoprhuyl7pdujrn2a4vyule423xqovnoea53tu3j@j4pbbgdy232c>
From: Song Liu <song@kernel.org>
Date: Thu, 19 Feb 2026 13:31:12 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7thkVXs7co2-4CpaJN5UYOik-4X4zj3QeP=K=3Ef7fEw@mail.gmail.com>
X-Gm-Features: AaiRm51Oqduasd3g5MvGabnPSkw34Kv32bwxl2ZQikaQzkJIT3CJMK1HqNtNZnU
Message-ID: <CAPhsuW7thkVXs7co2-4CpaJN5UYOik-4X4zj3QeP=K=3Ef7fEw@mail.gmail.com>
Subject: Re: [PATCH 0/8] objtool/klp: klp-build LTO support and tests
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2052-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 7FEC2162CF8
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 12:51=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
[...]
> >
> > Thanks for the test case. This one shows the worst case of the .llvm.
> > suffix issue.
> >
> > We have
> >   c_start.llvm.15251198824366928061
> >   c_start.llvm.1768504738091882651
> > in the original kernel, and
> >   c_start.llvm.14107081093236395767
> >   c_start.llvm.10047843810948474008
> > in the patched kernel.
> >
> > All of them are GLOBAL HIDDEN functions, so I don't think we can
> > reliably correlate them. Maybe we should fail the build in such cases.
>
> I'm thinking the "correlate <orig> to <patched>" warnings would need to
> be an error when there's ambiguity (i.e., two symbols with the same
> ".llvm.*" mangled name), as there's nothing preventing their symbols'
> orders from getting swapped.

Agreed. I changed the logic to error out when there is ambiguity.

> And note that changing a symbol from local to global (or vice versa) can
> do exactly that, as globals always come at the end.
>
> Also, this problem may be more widespread than the above, as there are a
> lot of duplicately named functions in the kernel, with
> CONFIG_DEBUG_SECTION_MISMATCH making the problem even worse in practice.
>
> I think we may need to figure out a way to map sym.llvm.<hash> back to
> its original FILE symbol so correlate_symbols() can reliably
> disambiguate.
>
> The hash seems to be file-specific.  I don't think there's a way for
> objtool to reverse engineer that.
>
> DWARF could be used to map the symbol to its original file name, but we
> can't necessarily rely on CONFIG_DEBUG_INFO.
>
> However, I did find that LLVM has a hidden option:
>
>   -mllvm -use-source-filename-for-promoted-locals
>
> which changes the hash to a file path:
>
>   c_start.llvm.arch_x86_kernel_cpu_proc_c
>
> That would be (almost) everything we'd need to match a symbol to its
> FILE symbol.

I am aware of this option. I think it makes kallsyms too ugly tough.
Also, at the moment, llvm adds these suffixes even when there is
no ambiguity. As a result, there are too many of them. Yonghong
is working on a LLVM change so that it only adds suffixes when
necessary (https://github.com/llvm/llvm-project/pull/178587). But
this won't be available until LLVM-23.

At the moment, I think error out on ambiguity is probably good
enough. This should not happen too often in real world patches.
Does this sound like a viable solution for now?

Thanks,
Song

[...]

