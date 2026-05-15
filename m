Return-Path: <live-patching+bounces-2835-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6PZ/LUKRB2pU9AIAu9opvQ
	(envelope-from <live-patching+bounces-2835-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 23:33:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2873E558305
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 23:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA2C030FB5C2
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 21:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FF3A3ED5AD;
	Fri, 15 May 2026 21:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szPKIhRi"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA3D3ED128
	for <live-patching@vger.kernel.org>; Fri, 15 May 2026 21:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778879942; cv=none; b=avVoRyi4nRHpOaMM4zE1cjcdIVqmbtCDFG+lVi/MyR2yyGtYEnRZ55kjZlj5o5ii70bjKQ3xcIRnzVyWRqrE1DubjVs3cV9rhVDg4dO/KMIuWLyo/qBWjDzf2JznUfbKGfOTQprQ6YAvVwHsVAru4kxG+S6GFqJ90GmDMcqO8FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778879942; c=relaxed/simple;
	bh=S6/5n/eY5SBAzU2YfEnW0M7mbgHygbpeduVPRCNsd8w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rza8PsxjAF6mOLAe4ji8smQK0gYnSGk5CC2EnO5t0ze8dR7hbQErjgEyjz+uDwrwOM7XtWmnZOfexvl5/b8rzAuETvsWYt4+tXrooJtUONyhQJ0xRPGyAkbuZw1HE68NGbS5PU1rtsM6GkvZq78Zyhe08/LMHEf7hUwylJj68lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szPKIhRi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371F3C4AF09
	for <live-patching@vger.kernel.org>; Fri, 15 May 2026 21:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778879942;
	bh=S6/5n/eY5SBAzU2YfEnW0M7mbgHygbpeduVPRCNsd8w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=szPKIhRi+/8AqpqvN8IRpi1Moy1C7m9duw4rfSX22utImDW4Ga3q/gvy6EQNELj6B
	 CHsbYpb0xDfYiPy9XD8ak3rLsaQPD950edVpaBRJIeJoYiWfgAmndUBwEykVxE8EPX
	 op+iLUGUeeNb8th3OqomdM1ZkA7Llbm7JIwPdvzoEs+NzSgRhLdxHK+8yqtDWGMzVN
	 CgVcWkzQDzim9YEBvl5fJKsZzeC5lCd4B+S3JOc2sQuHRTwBjknni/7g0wqgDYQuVt
	 RjnysyksI07hTBa6ClvSJ4XKHEpitMitOq4WTJoJ6NGnFbJuorhFkhzuJqHwUZLaCX
	 BYEyzY9TzCqzg==
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51306c9f2e1so5179801cf.0
        for <live-patching@vger.kernel.org>; Fri, 15 May 2026 14:19:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9+qTMfp5kaR2enUdEQhLzna0Q0MXjQCM5AxafaQnMWt6zy0d8WIckAT4pFM529PRmoSPW1DjvvYFTwC7PH@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/OY/hvAGGCKGFIoYb77yWZdGwp4ruIn7HROsodWc+F+m35083
	dpaJU+PYi9NjdR5UTg6vlQaIpAWf6YFFUyBArISCguawiy7qaiaIYtlIrhsoKPzQShAUeHD8r0j
	Hy06zVELgVuo+iU3iM14rpcvATHGZZDs=
X-Received: by 2002:ac8:7d53:0:b0:516:51da:ae52 with SMTP id
 d75a77b69052e-5165a1e8b62mr79944801cf.33.1778879941192; Fri, 15 May 2026
 14:19:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1778642120.git.jpoimboe@kernel.org> <74623fad8c45d26a3da6c5420b00156d8f7c2150.1778642120.git.jpoimboe@kernel.org>
In-Reply-To: <74623fad8c45d26a3da6c5420b00156d8f7c2150.1778642120.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 15 May 2026 14:18:49 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4G5H979FCvk0tfebOxjBcMak5n3Cx8YB6yhtSLaJiGzw@mail.gmail.com>
X-Gm-Features: AVHnY4J8krqK1Xboui47oB88bHhzXLaHBxExeYAz32cX9_pfyW7wyKMKsDyD1kQ
Message-ID: <CAPhsuW4G5H979FCvk0tfebOxjBcMak5n3Cx8YB6yhtSLaJiGzw@mail.gmail.com>
Subject: Re: [PATCH v3 04/21] arm64: Rename TRAMP_VALIAS -> TRAMP_VALIAS_ASM
 in asm-offsets
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2873E558305
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2835-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Tue, May 12, 2026 at 8:34=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Rename the asm-offsets TRAMP_VALIAS macro to TRAMP_VALIAS_ASM, following
> the naming convention already used by PIE_E0_ASM and PIE_E1_ASM.  This
> disambiguates the asm-offsets-generated constant from the C macro of the
> same name defined in fixmap.h and vectors.h.
>
> This is needed by a later patch which adds new includes to asm-offsets.c
> that would otherwise conflict with the C version.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

