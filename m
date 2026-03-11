Return-Path: <live-patching+bounces-2192-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CNRsGxT4sWl7HQAAu9opvQ
	(envelope-from <live-patching+bounces-2192-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:17:40 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA6E26B4B4
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 52CD030E73B2
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:15:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E593A257C;
	Wed, 11 Mar 2026 23:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ooyPSvBC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738463A1E81
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270941; cv=none; b=GYhFVCApHj2EgSWctsnzB2nlOOQNwnQdW5ZwioRi52tvnfTdsdxXn94u+YHhtjaHgL1eaPu7vGXzApMkPZCSU+yX86+oCb0mT9zwtBSsaEN3GVOe9zkzkc8zwFkBd7Wd34patLoj+7UuFhif3wvUxfWBLBnPzIhOh5/mMc3q8tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270941; c=relaxed/simple;
	bh=tAX27w1ClGrm27ttzVo75rXyxC8Tz6Oha3WktnTKOE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H0Cx1fjudQzpftA/h2CtXJbQgL3spCiWFbxuF7leMmrhkqRi+BL51E2lBgNwvVuPXhK4oo2/28mPN/71J75jo0ekU3p4CHpnl5zzTjrPDNhHbpK5B5Eg3Qhv3xV21g2eAEnSJhbXfE23Goei3jFiHFh/U5NIGqrKJoxMxG9/CT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ooyPSvBC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B26EC4AF09
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270941;
	bh=tAX27w1ClGrm27ttzVo75rXyxC8Tz6Oha3WktnTKOE0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ooyPSvBCFajql2Ep/5K5qokahjigO0axg2RMrdykjnm+XGhXr/OnrUpNUNQuh91Oe
	 DDHtl+6OVGW2lNNZRZL7msM1I2HNIjLEBN1Xsy9Gxi0eLdl4CVdjegPaww5ifaGArT
	 HtqRq8UWP5PS0PQdDDhoJhy9HjA54LaP+vL4TMoEteM+qZSM1Ujfd7btbMvvcX3mU0
	 qQdTi/C7VXotc7liFbfr0GnJH2Y4GbruiV3rzR4itcemMrr92zDgODQzKNB0vYdaMC
	 HxwfdNxQVl6fzax/n6O43FWg2Qfa0iArCp6PYpLk+LJ6riZGi9iongyi8/hMw0UXUS
	 k8UaYXmaaju4A==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-899e87b04d8so6829816d6.3
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 16:15:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX79RoUYqpfGjGvsJCmmyjLi2QyNYZ+d0z7PLlPhCk4S+s0zAhe3pWevkpsnuxwssBbJXhXc/smc+s1Pwf2@vger.kernel.org
X-Gm-Message-State: AOJu0Yyba6GOddIQRzKQ0nsf0CjzsArEgV0iZiEl4PleGWJAtpRyl1Jf
	oNWOjHSCvZAgu5Q2rvuqso9vZpDdXFcIVWu54csS8/CiXIc5T2ta7tt9YRccWDJ0l2DAQogVfs9
	BwTPAtXuhGEj1dcmalCp6GOZUBNJeoAc=
X-Received: by 2002:ac8:5893:0:b0:4ff:c17b:5ab0 with SMTP id
 d75a77b69052e-50939f6cc8bmr61579481cf.9.1773270940398; Wed, 11 Mar 2026
 16:15:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <1cdd2737d2db5a300eea971382c5e8edda7fb474.1772681234.git.jpoimboe@kernel.org>
In-Reply-To: <1cdd2737d2db5a300eea971382c5e8edda7fb474.1772681234.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 16:15:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7DXkCpuA-K8KJz=ViG4fJTVhpXbiYoEs5LjwrQRYoeqw@mail.gmail.com>
X-Gm-Features: AaiRm52pQjRmKTr96uU394J28OHiIKkdK4Vv2r4jR0PViDmqztJOGlWlW8qDkxo
Message-ID: <CAPhsuW7DXkCpuA-K8KJz=ViG4fJTVhpXbiYoEs5LjwrQRYoeqw@mail.gmail.com>
Subject: Re: [PATCH 12/14] objtool: Reuse consecutive string references
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2192-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BEA6E26B4B4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 4, 2026 at 7:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> For duplicate strings, elf_add_string() just blindly adds duplicates.
>
> That can be a problem for arm64 which often uses two consecutive
> instructions (and corresponding relocations) to put an address into a
> register, like:
>
>   d8:   90000001        adrp    x1, 0 <meminfo_proc_show>       d8: R_AAR=
CH64_ADR_PREL_PG_HI21  .rodata.meminfo_proc_show.str1.8
>   dc:   91000021        add     x1, x1, #0x0    dc: R_AARCH64_ADD_ABS_LO1=
2_NC   .rodata.meminfo_proc_show.str1.8
>
> Referencing two different string addresses in the adrp+add pair can
> result in a corrupt string addresses.  Detect such consecutive reuses
> and force them to use the same string.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

