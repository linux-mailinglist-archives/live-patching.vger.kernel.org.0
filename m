Return-Path: <live-patching+bounces-2797-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eOJYKdFDBGp0GQIAu9opvQ
	(envelope-from <live-patching+bounces-2797-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 11:26:41 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 092C75309A4
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 11:26:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E572331D735F
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 09:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CF3E3E5A20;
	Wed, 13 May 2026 08:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nCKpHFbX"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164563E4C69;
	Wed, 13 May 2026 08:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662652; cv=none; b=soZXpD9TJpJaZ8W61sfm4z1Hs3EZ+oa/B83gtpUWfhi7NiFtRIqrC+Qx2sZop4062fFAtNCRDeBhE6vChr0tcmx3adbVs+OJ8lRc7C80i2snxhIzWti98t4tTGpre6E8M4c5uvp6K+WOUalKYTRiZDYvuHQdX8ixceD2YotbrKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662652; c=relaxed/simple;
	bh=qn5GA6lY9PvflO9P8xrWta1ntoOX5i4amwqf2P97V+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S33jfViFICcfQV/khrbpbiRYa+IkCHMVUbMuOVa9a/iiMQ1IYSmL8o2degP9nf8QI5uTdo0rK6Sg4q6+lsvdf7yMhDD+gSZ04oxtffU2DrDuQ3SsO4+hGjIzULXdqfOQnb0/Y06DCzdjq5Bb74crMlfC5k7vKX5WH9khAB05CpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nCKpHFbX; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LcRidvPYK4SO7i56E+hQhDbVPy+f03hM5L256hH5oME=; b=nCKpHFbXjvGq5b4TX2suEwInFJ
	NhEz4378zW/CjVe3PVBlVvsEZ9A6Bt6rdNIWxu8KBYRnmYlG/FQnHudJQ1euf0PdL8hM2tF8Pmcmd
	RQFdYBBWeLuPBAqVWdxftbFkl8wLAW60jG3QR6N5ePhummQ4EFVRLPrXzu66eh1lxgv6+Pq2Qznvt
	8vwtLIbN5P32vK4BKxCT0EWtjKfMl6DFUeaZhrGZFHsIw2OLOxYkeprlhX1O4MUXrUPBdVdTFXzY/
	BrYeLDJPAmacl6FKE85ODX1ACdHiX/CeetgeEtvh/RBgdYiO2wLJt2tHxwnKVDNc9o4I0HImR8EIi
	2terZodw==;
Received: from 2001-1c00-8d85-4b00-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:4b00:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN49X-0000000GmYs-48vX;
	Wed, 13 May 2026 07:39:37 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CC0A0300BDE; Wed, 13 May 2026 09:37:11 +0200 (CEST)
Date: Wed, 13 May 2026 09:37:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 11/21] objtool: Allow empty alternatives
Message-ID: <20260513073711.GI1889694@noisy.programming.kicks-ass.net>
References: <cover.1778642120.git.jpoimboe@kernel.org>
 <3c474673ec5ddc9f27fbf5ddb1fd0f66ef6a779f.1778642120.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c474673ec5ddc9f27fbf5ddb1fd0f66ef6a779f.1778642120.git.jpoimboe@kernel.org>
X-Rspamd-Queue-Id: 092C75309A4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2797-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:dkim,noisy.programming.kicks-ass.net:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Tue, May 12, 2026 at 08:33:45PM -0700, Josh Poimboeuf wrote:
> arm64 can have empty alternatives, which are effectively no-ops.  Ignore
> them.  While at it, fix a memory leak.

How does this happen?

