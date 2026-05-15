Return-Path: <live-patching+bounces-2830-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wMYUGdaIBmr0kQIAu9opvQ
	(envelope-from <live-patching+bounces-2830-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 04:45:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CF0AB548D2D
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 04:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A5032303525F
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 02:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19F443C2785;
	Fri, 15 May 2026 02:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pa6o4Llx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD533C2777;
	Fri, 15 May 2026 02:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778813081; cv=none; b=b9kg9oJe9+rNTTFUYugzOW2qG3SxNqNvcZxYUOPZKPfZPqVaJQGUeNo+3UlXuqPxnX0mSpfDO/LbOrFVm6IRcmzflaQObKXgmm5M6oeIKQD87rjs2CfvUgN+hnbxoAXh4XtLd9mwLrm4bjB+9WnV265rJnhJA8oQNBTG5nm9Jck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778813081; c=relaxed/simple;
	bh=xddcZ6kMGB/rYMEe75+BVJi4hJyQUito4b9gPm8fIH4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G34FLN8/wmxn1D3GgZd/9Gh6Bnf7HAa1xCbdc5mnf0a4206KKGzjDC3PUi1DS+vAcAdPJBS86Z7eaEJmbb+IrRkVhw09JlzMYk8dfuLUzHiaEhAU3h0XGXkgiYCktxy7zgVhvPKtD9iTV2AACAy4PkuG1nkMK9Ne4/N6tfjsSbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pa6o4Llx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2B7C2BCB3;
	Fri, 15 May 2026 02:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778813080;
	bh=xddcZ6kMGB/rYMEe75+BVJi4hJyQUito4b9gPm8fIH4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=pa6o4LlxYgmirQt3ntPFMTLSJDXIAwZIOH9BQDvGw+2rFq7bMQUumud4wBa3/93kl
	 gb72mifNw4QLgld1sRYfhZbUzYQWYCRTSy+SEHYeOIgO+rIsJpwtAllPA+Qs8+UvvI
	 Rz96xPcOQtUzsnnqTVm/nlYqQJe/tzKErYoBMqll8NviSZIc6zlx2tbzew9o3S3JFf
	 620nORRqfWEZ+RmQ6wCaLewA6Z63H35S9Nc4rG2lbXHSHjTaweyWkBmZvX/hu9Rwmk
	 TnvfXN9XcY+y4n6Io8U4VvMdbhiLFgM3ToV1rkx+DI3SrG3f52ex8A5/N3crhtBAzw
	 aKHgbYJmNCuaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 21/21] klp-build: Add arm64 syscall patching macro
Reply-To: sashiko-reviews@lists.linux.dev
To: x86@kernel.org
Cc: "Miroslav Benes" <mbenes@suse.cz>, live-patching@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, "Will Deacon" <will@kernel.org>, "Joe
 Lawrence" <joe.lawrence@redhat.com>, "Catalin Marinas" <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, "Mark
 Rutland" <mark.rutland@arm.com>, "Song Liu" <song@kernel.org>, linux-kernel@vger.kernel.org, "Petr
 Mladek" <pmladek@suse.com>
In-Reply-To: <3bf3cee43039fc4da84e83d0891a92e25f40f00f.1778642121.git.jpoimboe@kernel.org>
References: <3bf3cee43039fc4da84e83d0891a92e25f40f00f.1778642121.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 15 May 2026 02:44:39 +0000
Message-Id: <20260515024439.AF2B7C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: CF0AB548D2D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2830-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,sashiko.dev:url,lists.linux.dev:replyto]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The arm64 __KLP_SYSCALL_DEFINEx macro omits the ALLOW_ERROR_INJE=
CTION declaration, silently breaking BPF error injection for livepatched sy=
scalls.
--

commit b4d1a9ea352f196a7fd3e7198fdade51440d08e5
Author: Josh Poimboeuf <jpoimboe@kernel.org>

klp-build: Add arm64 syscall patching macro

This commit adds arm64 support for KLP_SYSCALL_DEFINEx(). The commit
message states it is mirroring the arm64 __SYSCALL_DEFINEx() pattern from
arch/arm64/include/asm/syscall_wrapper.h.

> diff --git a/include/linux/livepatch_helpers.h b/include/linux/livepatch_=
helpers.h
> index 99d68d0773fa8..4b647b83865f9 100644
> --- a/include/linux/livepatch_helpers.h
> +++ b/include/linux/livepatch_helpers.h
> @@ -72,6 +72,25 @@
>  	}								\
>  	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))
> =20
> +#elif defined(CONFIG_ARM64)
> +
> +#define __KLP_SYSCALL_DEFINEx(x, name, ...)				\
> +	static long __se_sys##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
> +	static inline long __klp_do_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
> +	asmlinkage long __arm64_sys##name(const struct pt_regs *regs);	\
> +	asmlinkage long __arm64_sys##name(const struct pt_regs *regs)	\
> +	{								\
> +		return __se_sys##name(SC_ARM64_REGS_TO_ARGS(x,__VA_ARGS__));\
> +	}								\

Does this macro definition omit the ALLOW_ERROR_INJECTION declaration?

The standard arm64 __SYSCALL_DEFINEx() macro explicitly registers the top-l=
evel
syscall handler with ALLOW_ERROR_INJECTION() to enable BPF error injection
workflows like bpf_override_return(). The x86 implementation correctly
preserves this functionality.

Because this macro is missing that declaration, it looks like it might
introduce a regression where BPF cannot inject errors into the replacement
syscalls in a livepatch module on arm64.

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1778642120.gi=
t.jpoimboe@kernel.org?part=3D21

