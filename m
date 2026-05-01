Return-Path: <live-patching+bounces-2678-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gAOnDM6C9Gn8BwIAu9opvQ
	(envelope-from <live-patching+bounces-2678-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:39:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94B424ABB1C
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 039F8301915F
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5931038758A;
	Fri,  1 May 2026 10:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDdtubVO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37022387372
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631943; cv=none; b=F3uYb9Uj5ejIonq/JNkH+cfW3WWJ5d4ro7ZpW1zY5EYvCXpd1+DSEMw3fFNPaTgrbpRkRb/8c0dZnh4sQ+xOJfJdc6y2Kx5Cm4ugguFIK4yngiddiLzuQGAAR6YDjbAdUyVfg1tBHRMaaX9YjFj9s7qm0lkFp9r0whh0iLc86h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631943; c=relaxed/simple;
	bh=lTZSyzptdLS+tv+EB0+Iik1f7+0eFiN9oPWal6VbfjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rl7euYSuZM3S9IwR5GNuqbM7PjMxALk89VM+K1vsXAr0qnmwCsLAANVnvbMRWLYk+9lONy/fKklXIeYjdu6fR6ssKDRVP820L1ovkBxVsBAG0wVK9DZxhbSiptPNc8d/55gYaRMjQMLDV3RgJH6/kl9GXNNrfAy7eguGPe2+xxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDdtubVO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9C3C2BCC7
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777631942;
	bh=lTZSyzptdLS+tv+EB0+Iik1f7+0eFiN9oPWal6VbfjI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VDdtubVOP9HbloNPBwMxOu4dDLvtIb0OQThbPy4/ZNDgwmKSz/KgRzWif3lNVYDAG
	 DFUxSn46bF4u/tOG/6SnphSFGn1UOxkhV/7TydZYDu0YxwXPenyC2OGk48tOBa+Z6e
	 TPi5XSVuVJznohehkySbQKbRCP1MQL3vyyBUb4bhDl69+pmCcanAdjgFYQKJC502da
	 UhWCCGjbtsY7F6Ke1e6QU+5ETXZHPntI/0OIE4NLKIcKQ76TY69dOVGjBK4XBrwp/l
	 HnSaj0w97Nz5C9qWfpsIIN0q2PsZ4bZPqKJe8r230w/ZpeVhc+L/AuuebBlku/XvwW
	 G1sgGg+5Ik9zA==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a08fa355a1so25716336d6.0
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:39:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9pgviCBXymuy4HfvsLcLj28egLq/0Dq6c/nWkYD5JZ9+PizY0rrspZEDvQnUPlzYaC7L9ifZbX2xz/CQTl@vger.kernel.org
X-Gm-Message-State: AOJu0YxDFX/jL7Vw6QPfrnUq6729GLFt8EN5MHrVTDMb+7qGGQy9PnVd
	f/CJMuazsI2pURWDE5obek+jq9+aAjW3Ol/U9pJlQzlaOC5iqxW/gX9IssEVk2dFjWa9CqFUUZ/
	6I9ZNCiolLuLykgiloCUIQYChcjd0UMU=
X-Received: by 2002:a05:6214:3d0b:b0:8b2:138d:32e8 with SMTP id
 6a1803df08f44-8b3fe732403mr111901436d6.21.1777631942126; Fri, 01 May 2026
 03:39:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <9b419d82a20dbc54be4a59cfec04ab13987a2e6c.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <9b419d82a20dbc54be4a59cfec04ab13987a2e6c.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:38:48 +0100
X-Gmail-Original-Message-ID: <CAPhsuW6rM+Zd6zWBT2Mg61rn-Gy91JJBtsOftSYBeryT4hgOqw@mail.gmail.com>
X-Gm-Features: AVHnY4Jiho7C5nQX_-fsGR4ryM16V11_NLvGz6gS7WcSM7rfQIHPj6Hd_iF-gdU
Message-ID: <CAPhsuW6rM+Zd6zWBT2Mg61rn-Gy91JJBtsOftSYBeryT4hgOqw@mail.gmail.com>
Subject: Re: [PATCH v2 21/53] objtool/klp: Fix reloc corruption in convert_reloc_sym_to_secsym()
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 94B424ABB1C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2678-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:10=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Use the section symbol's index instead of the old symbol's index when
> updating the ELF relocation entry in convert_reloc_sym_to_secsym().
>
> Found by Sashiko review.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

