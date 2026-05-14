Return-Path: <live-patching+bounces-2822-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KAi6AddLBmqUiQIAu9opvQ
	(envelope-from <live-patching+bounces-2822-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:25:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id F29775476A2
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:25:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 546293013D40
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 22:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 313503D1AB0;
	Thu, 14 May 2026 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AA1BYrod"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFD73CF977;
	Thu, 14 May 2026 22:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778797518; cv=none; b=nIK4UstiNwdyTsmw7ybNJwiRXM7OVldMDT1l47Rvzqm3YWDjKGhpwn5/JHz+g32BdnZ4OzUQ/IDNc7a6ngC4uQaU3cCEZqqGW4zkUF/e7rUsHFrH1+QxeWbhp9D75kvAffma45jnUj+l8eQCxcJkSftg/GZ9ZlGUPMygXZoao50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778797518; c=relaxed/simple;
	bh=l4n1GCkss3HdumT9TYk9D1dQsWaT9kxRVhMfzwbcBDM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=YPktk+Xq2expxcEFDWSwNwqdYXZAeL0RqmZNOpFRMhiIbylsJ0ONzEG2dAq8BSe+6YpOxHQtLtAG8MF9myk0trnewkP3iXnWM3MfucscVMpQPZbzPE1ofOW3ahSJuKn5BGIAtXbX3YMKvbCfUe9LTE3vDIEwXesD9aVJYHlSaKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AA1BYrod; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2437C2BCB3;
	Thu, 14 May 2026 22:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778797517;
	bh=l4n1GCkss3HdumT9TYk9D1dQsWaT9kxRVhMfzwbcBDM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=AA1BYrodfUHXEl65jh+fNAg+8mo1kGu/2Jn7U16Af+p0xZjpjjeVcVypmIjHWFAeN
	 NnX0xWg4UulKnyi0CdfCwAs9eWf9S5L0X6UIFX2sMn423HC3Rfgah3UHGleTMxMMgu
	 wHo46egB7gv6NCD3PGDz6yNNbhODIuqC5joMUFqdE04QYrwL/80N7Qtxgju7vL+Tih
	 romzAo6uuFLMuDRDQm4hvE3Afz1z+lCcFMdnYrDxQd+ipgmKqZqVIu/3TVhelVNBl+
	 cUVEivtUcxAOpJLOzi/OKwFLkM5o3YzYnd9OnELchlN4+yrLgyXDq/GP4eyAyvTLsk
	 6tEx23VluLYGg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/21] kbuild: Only run objtool if there is at least
 one command
Reply-To: sashiko-reviews@lists.linux.dev
To: x86@kernel.org
Cc: "Peter Zijlstra" <peterz@infradead.org>, "Song Liu" <song@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, "Joe
 Lawrence" <joe.lawrence@redhat.com>, "Will Deacon" <will@kernel.org>, "Miroslav
 Benes" <mbenes@suse.cz>, "Petr Mladek" <pmladek@suse.com>, "Nicolas Schier" <nsc@kernel.org>, live-patching@vger.kernel.org, "Nathan
 Chancellor" <nathan@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>
In-Reply-To: <8699672b82fef17e73a5f2e5528478778dbdab31.1778642120.git.jpoimboe@kernel.org>
References: <8699672b82fef17e73a5f2e5528478778dbdab31.1778642120.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 22:25:15 +0000
Message-Id: <20260514222516.D2437C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: F29775476A2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2822-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[smtp.kernel.org:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,lists.linux.dev:replyto,sashiko.dev:url]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Leaking objtool options into vmlinux.o validation causes a fatal bu=
ild failure (`--cfi requires --prefix`) and silently alters validation beha=
vior.
--

commit 68e454f3a8ccd3d638c67c092eee264996286695
Author: Josh Poimboeuf <jpoimboe@kernel.org>

kbuild: Only run objtool if there is at least one command

This commit splits the objtool arguments into commands and options to
prevent objtool from running when no commands are enabled.

> diff --git a/scripts/Makefile.vmlinux_o b/scripts/Makefile.vmlinux_o
> index 527352c222ff6..09af33203bd8d 100644
> --- a/scripts/Makefile.vmlinux_o
> +++ b/scripts/Makefile.vmlinux_o
[ ... ]
> @@ -36,18 +36,13 @@ endif
>  # For !delay-objtool + CONFIG_NOINSTR_VALIDATION, it runs on both transl=
ation
>  # units and vmlinux.o, with the latter only used for noinstr/unret valid=
ation.
> =20
> -objtool-enabled :=3D $(or $(delay-objtool),$(CONFIG_NOINSTR_VALIDATION))
> -
> -ifeq ($(delay-objtool),y)
> -vmlinux-objtool-args-y					+=3D $(objtool-args-y)
> -else
> -vmlinux-objtool-args-$(CONFIG_OBJTOOL_WERROR)		+=3D --werror
> +ifneq ($(delay-objtool),y)
> +objtool-cmds-y					 =3D
> +objtool-opts-y					+=3D --link

Does this code unintentionally retain the options from scripts/Makefile.lib?

Since objtool-cmds-y is cleared here, commands like --prefix are dropped.
However, because objtool-opts-y is only appended to, options like --cfi
remain active.

This causes objtool to fail with a fatal error: "--cfi requires --prefix"
during vmlinux.o validation on configurations with KCFI.=20

Should objtool-opts-y be assigned directly using =3D or :=3D instead of
appended?

>  endif

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1778642120.gi=
t.jpoimboe@kernel.org?part=3D9

