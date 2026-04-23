Return-Path: <live-patching+bounces-2495-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOskC/ZL6mkhxgIAu9opvQ
	(envelope-from <live-patching+bounces-2495-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 18:42:30 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86FFE4550EA
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 18:42:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EABB430C3A2F
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 16:34:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD4C37DE9B;
	Thu, 23 Apr 2026 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XB1UyrSf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10B7371CEA;
	Thu, 23 Apr 2026 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776962047; cv=none; b=SUByR4C+J2TEpmqhTS1pDCspNO76Fjeb2Sy7qrutdicfvM5m0mZNVNSovr9aTJgfW5CDz/Qq1RhX3SbfuYGeTGQsV+YPXfqf+/xFtBLQYN//E4ozdeuRtSAhiCy5kT62exkxESmGGBbaWPX932Oh6JUz+kqV8SZYwwz48u4CfUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776962047; c=relaxed/simple;
	bh=yEXlugjbdj/wnn1IrXOzNm4CLnI98gZyrDc/i0X7YKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nFpjSs5gXkVqM3ihYewDg+QRxNYdqZ+DN2dQgIQT82yV1xmq+gEZO0rr0ZxsGoUcxQSJCWHn831eYJm6vcL7Iw/YRWu6ZWJ6hI17eFv1BicwLH71ouIFQSkqmzNQIm8eHS9vXT2XQuHs8EtCSKwXMH1UUOgIRZd7LrYn+VQlkuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XB1UyrSf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92BCC2BCAF;
	Thu, 23 Apr 2026 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776962046;
	bh=yEXlugjbdj/wnn1IrXOzNm4CLnI98gZyrDc/i0X7YKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XB1UyrSfTKuXtr9bAq8VnkCq8TqnLOAUYZlzo34ih1SZJZjfce7frz86vMZcRG18y
	 Ebim6yDUEQSpHxSCv8G+Uu8578W5zxT+j1pvHBpu81EPSjXn/gwJ16zUQRGoi6tTOb
	 M7WGkJuhuIX2IIY97i+nX8AIhIrNWA+UEjD5V8neBfSLQZMzACjGBWWvCu233xaAOa
	 gC8qK2WdJfv21+2D4ofTWkQTZCk2lMpCi93G6OCYxevxaQe3T/hIIR8fc6qRHAgEmx
	 +YGs7JINqONzpwGCkvyMu0l2AzLUYQjTxara8RuKXknWtb/5TbVpQ+9Ve3xrkWsrHH
	 z8mzZ+b4lrrow==
Date: Thu, 23 Apr 2026 09:34:03 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, 
	Song Liu <song@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 17/48] objtool: Fix reloc hash collision in
 find_reloc_by_dest_range()
Message-ID: <dzwdrnewwsabz5zmbwkyq6tv4vqn6rauhfyuiywwsifxgh7bow@rplzpdtwsafc>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <09dab1995c4ba6ca29dd70b0a7472f1a2975fefd.1776916871.git.jpoimboe@kernel.org>
 <20260423083231.GS3126523@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260423083231.GS3126523@noisy.programming.kicks-ass.net>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2495-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 86FFE4550EA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 23, 2026 at 10:32:31AM +0200, Peter Zijlstra wrote:
> On Wed, Apr 22, 2026 at 09:03:45PM -0700, Josh Poimboeuf wrote:
> > In find_reloc_by_dest_range(), hash collisions can cause a high-offset
> > relocation to appear when probing a low-offset hash bucket.
> > 
> > Only return early when the best match found so far genuinely belongs to
> > the current bucket (its offset is within the bucket's stride range).
> > Otherwise, continue scanning later buckets which may contain
> > lower-offset matches.
> 
> Maybe mention (and or add a comment to the function) that in case of
> multiple matches in the given range, it will return the lowest address
> one.
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index c4cb371e72b2..af2841b8e095 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -347,8 +347,9 @@ void iterate_sym_by_name(const struct elf *elf, const char *name,
 	}
 }
 
+/* If there are multiple matches, return the first one in the range */
 struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
-				     unsigned long offset, unsigned int len)
+				       unsigned long offset, unsigned int len)
 {
 	struct reloc *reloc, *r = NULL;
 	struct section *rsec;

