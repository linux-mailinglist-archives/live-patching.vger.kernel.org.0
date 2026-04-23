Return-Path: <live-patching+bounces-2481-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ADsKFY7b6Wm2lwIAu9opvQ
	(envelope-from <live-patching+bounces-2481-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:42:54 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D856F44EAD1
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 10:42:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7E0A93005A89
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 08:42:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBAF73C6A27;
	Thu, 23 Apr 2026 08:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IPyyZawA"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6572F0C45;
	Thu, 23 Apr 2026 08:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776933723; cv=none; b=B6rW5CaIUNrp0V5ZjFh+U5VX8HSlTzFJQ6rSFI41NO79/L4hr1cNkjauYlpL6+uISFkJO/9wXMYMhqYxViZdp5ugS6JUu7VUFXeXtroB3bwbJeaWIHOERueVFz9vRnYEeygqJ7shf/pxTKq4OW6cKJA9gWq9jhUju8wimOXgZuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776933723; c=relaxed/simple;
	bh=MGbPRH7No0+ervXoqQaGO7HEXYLLqELAehHrRnUCPLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f46Z+kk+p07GN1S/ili32anel0TDEPDfYKBLvhLgs85Vh42S8pGQrlDoTUPn9EFDz/Gs+5lh9UouWxU45zqzyXvlPg4JXtRYqTzja+zJtnHuthVnJA/Ed9y+A5EakH8ymYQZa03dxC7SfEuOD2Gam4iwYP2U1emSiAfIN9wgzMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IPyyZawA; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pE/mgF4AcBafG9bpbzmN/fhRmbkTIijvilRU5lO+Fos=; b=IPyyZawAa2n7Ssee6yLRxUwviU
	XM/uPTJD2HuU7PAuMB08OrKSsNKh+yYH3DW+XfpTCetVAykzfKKZ69vkTJ2zuis8m4E+khSXvyU/O
	9bJP4pLP/jqekvfzKnuFS0C1ahRkokNm7qg3Z27+4bPc9JKqzuhsCIo/5XuE6W+OmJTVUBYFsZLsa
	XKTJLopJZIngPktfzGglpAFdmHbb4blwWI8dTjXnmt3FDoayzA6OdgK15e3Sx0h8uHW8bKfQs4k8J
	hMu3uXUFGgbHXLGdeJ7IPrpNhUxpNALg+nPYx8ZYPF+Yjp5YH8iracS3oEXh4oSc6SApwtvkggDW5
	EtKy1zZQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFpdI-0000000D841-0wFc;
	Thu, 23 Apr 2026 08:42:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BF55B3008E2; Thu, 23 Apr 2026 10:41:59 +0200 (CEST)
Date: Thu, 23 Apr 2026 10:41:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	live-patching@vger.kernel.org,
	Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 34/48] objtool: Consolidate file decoding into
 decode_file()
Message-ID: <20260423084159.GW3126523@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <1b6557569cbdf893b832c37ba16dafaf69f9c3f6.1776916871.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b6557569cbdf893b832c37ba16dafaf69f9c3f6.1776916871.git.jpoimboe@kernel.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2481-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[noisy.programming.kicks-ass.net:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,infradead.org:dkim,infradead.org:email]
X-Rspamd-Queue-Id: D856F44EAD1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 09:04:02PM -0700, Josh Poimboeuf wrote:
> decode_sections() relies on CFI and cfi_hash initialization done
> separately in check(), making it unusable outside of check().
> 
> Consolidate the initialization into decode_sections() and rename it to
> decode_file(), and make it global along with free_insns() and
> insn_reloc() for use by other objtool components -- namely, the checksum
> code which will be moving to another file.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

