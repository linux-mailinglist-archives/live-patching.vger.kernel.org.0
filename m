Return-Path: <live-patching+bounces-2491-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AHZJNkQ66mnYxAIAu9opvQ
	(envelope-from <live-patching+bounces-2491-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:27:00 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D17C454513
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 17:27:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A780730209F1
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 15:20:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04EB3327C08;
	Thu, 23 Apr 2026 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmB2V75T"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D662A31E853;
	Thu, 23 Apr 2026 15:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776957599; cv=none; b=eTLJ1tltp2t4UqDHbKBvbhaLRbV/RyoRHyPyXrwG0weZAmQ73E0MPbYK9LAQeOU0TjPu84Ztk/ohdOYL++4bhqct+oaUE3cl3TczyL2IhLKr21znh/LJkCpoU2eqooACj8qLCbYrB5llWoDy4XCvO5C/FCHwdyJyaxtCMP2mifU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776957599; c=relaxed/simple;
	bh=5rHaQ8TgXqeARUY/4fzso9hcLkGU4zJwqLvX70ZnYM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p3Bpkl34d6Pdmnq1ngyBKm7ef0jwTxIL0dsnHxINOXVSF+dXfhfIWR38nJwaTufYImwArSm5GKyexj9tjnr9AUDMY5K8y8lIG2hLW0dhVgrp6bKw1gVJN2QQoSAuvGSN8YmhSYH6M8XHGyOZ83ogG60NKlNkmbI+OgqHP3voE/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmB2V75T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3707C2BCAF;
	Thu, 23 Apr 2026 15:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776957599;
	bh=5rHaQ8TgXqeARUY/4fzso9hcLkGU4zJwqLvX70ZnYM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KmB2V75ToVMSza82sxa8LtKuA4H46lS6Tiek5FUZ8QYXH9Qdbtm5wSCe1An6J3gIw
	 ATR7xZWMQExfWjPU2n3BQk6Dqg7qhEWQszOBICciiAVpYXE2OWCiTtMcU2Bam0JkAp
	 /q0X611HEUY0RY6oF2WScrchWs9Wec7He0AZLhvXX7Lt++AURWXeAMrK6zuljTkZQo
	 9JQsVk//vqTO8LdDq7g+8vcFKHuBsyNbG/vvvM3qtsLmu9LQeNBWtrJzHqYrEfbiUR
	 RVnsC3o+rgE/iYNRUVC0MSJzWr9+n5SOj/DNG9/HdU0XzsOYF+it09JGEbup7E+s6N
	 p7LxzN9rADhnA==
Date: Thu, 23 Apr 2026 08:19:57 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 47/48] objtool: Improve and simplify prefix symbol
 detection
Message-ID: <be5iv2gj7mfmizs6v3dsygnv2c2tn7aniabz3fopgrbnnnfdnj@433avj4qybyp>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <45d385f7112ccb71f991a8524e3f9f48b37c1fd9.1776916871.git.jpoimboe@kernel.org>
 <20260423085520.GZ3126523@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423085520.GZ3126523@noisy.programming.kicks-ass.net>
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
	TAGGED_FROM(0.00)[bounces-2491-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2D17C454513
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 10:55:20AM +0200, Peter Zijlstra wrote:
> On Wed, Apr 22, 2026 at 09:04:15PM -0700, Josh Poimboeuf wrote:
> > Only create prefix symbols for functions that have
> > __patchable_function_entries entries, since those are the only functions
> > where prefix NOPs are intentional.
> 
> __CFI_TYPE() as used in SYM_TYPED_ENTRY() will also generate the NOPs
> but will not have __patchable_function_entries, because ASM not
> compiler.

Hm, but those already have __cfi_ symbols, no?

-- 
Josh

