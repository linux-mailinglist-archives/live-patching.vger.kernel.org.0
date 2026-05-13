Return-Path: <live-patching+bounces-2798-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yJSDHxJCBGokGQIAu9opvQ
	(envelope-from <live-patching+bounces-2798-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 11:19:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D0CEB530848
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 11:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B7AA310F643
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 09:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8A33FD14F;
	Wed, 13 May 2026 08:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jxH2RHIG"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0970A3E5A21;
	Wed, 13 May 2026 08:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662672; cv=none; b=ibRJPQurv5ayR2R7iJb0b63pOsHOvTPHoWtIidDfDw7B+IPTCE3FVmnEgE5Qvzi8pw8giigZ9KY2pLauLIZC55EFmflxjsP3SxpqRlTHNWiLJGCXcNYids4LIkty2TD5LJihjkDjTi1/N4bPDll00pPPIpBKLfvEb00mnpujYSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662672; c=relaxed/simple;
	bh=gdJ3bclZnSTQKqwObYZBerxCAeCGszQZnoiFN16hqOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLim9F0RHOyMtUuc9ia9JR39iYxhLAgPUFsD4maUAT676qLyg51F8QthA4kuQzrqMAch7h6rRUXRcihVyVTXElHimggM61ORWa32hLh/Yb1XlJWu/Mj/jetGJ5GiJIZYEmnmqF1mMSyid5v7W769lIZATK+NVudhBR2OXzZfNB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jxH2RHIG; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gdJ3bclZnSTQKqwObYZBerxCAeCGszQZnoiFN16hqOM=; b=jxH2RHIGgpbWLbhj4GX6/H7bA7
	9KdBf+V+KHOd8/CdiOJDvwU4MLhj2J1FYKYg6dxjhlfJXBUpB9dAieUECvHZCZb3XrSNX+Ux3iX4p
	X4gpvrliKWmsUCS7rMTDgWhW/viHbUhU0EvEgQzqDqkTQrmZgZ+BdNYRK7IOwoxZBdvrIRPJzeDmR
	XDhXKKtkUFgi7B54UUYw8/wIMhF+4VYsH88qAJOyuDGLbiZ2l3J+rj8gGEDdYqPaTbNmEqPZuk5/N
	7riIpmki61aDnODvz6+CrX+r1EHIM0x4eSvEMLeQF5KJ7Ne48XNelij3hspk1K8X7HUBwjei2nesX
	/A+srvSg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN48g-0000000GmWa-3fiV;
	Wed, 13 May 2026 07:38:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 94A4A300B8A; Wed, 13 May 2026 09:36:17 +0200 (CEST)
Date: Wed, 13 May 2026 09:36:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 10/21] objtool: Ignore jumps to the end of the
 function for checksum runs
Message-ID: <20260513073617.GH1889694@noisy.programming.kicks-ass.net>
References: <cover.1778642120.git.jpoimboe@kernel.org>
 <b3b58101e15e1bb5266e57134f0b65f7d8efdd4b.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3b58101e15e1bb5266e57134f0b65f7d8efdd4b.1778642120.git.jpoimboe@kernel.org>
X-Rspamd-Queue-Id: D0CEB530848
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2798-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Tue, May 12, 2026 at 08:33:44PM -0700, Josh Poimboeuf wrote:
> Sometimes Clang arm64 code jumps to the end of the function for UB.
> No need to make that an error for checksum runs.

I'm not sure I understand the rationale. If the compiler trips UB, we
want to be complaining about that no?

Same as when clang just stops code-gen, also something we commonly see
when it hits UB.

