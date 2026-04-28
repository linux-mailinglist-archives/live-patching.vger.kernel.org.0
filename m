Return-Path: <live-patching+bounces-2573-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLX9F/us8GnOWwEAu9opvQ
	(envelope-from <live-patching+bounces-2573-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 14:50:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D296485151
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 14:50:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1CE033027260
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 11:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8098E3B38A1;
	Tue, 28 Apr 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="skh4n079";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+PnFriYR";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="skh4n079";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+PnFriYR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578843ACF0E
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 11:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777376770; cv=none; b=hSv2lMM+McyWxPCllT+OWgXr3BAXMY4zWUVjXzzU7G1ZqepHkXIIQut4X3B9on+GaZORcXv+OxFLGodlLgreKESlbbceMQY3QSB0dNKKhsps2Ig1VZOBCuUVJgUeLUNhonRP5qPqbJ5o+eqMIHuOJvsQ9RWJtbEilnwqameDTFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777376770; c=relaxed/simple;
	bh=J+PDaaj2juRWUDo7k4jbS1nHj8aLRLOR7CH9lbMuJwM=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=NwdEjMxr2mxlqRWDq60Ve2ampwbnoevDFp23Fgjmkdp915USZ4abBxjIiIrR31feNeItwwPxCMnBe/5ODwTuamJpWA0ynpg/6RxtxPPayu4wpp9iZuLNvJw28cMb3LLjKvNRAMHp3W0dkvqEcOf8TkPBZW+q6Tfn0RBcxhQ3bmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=skh4n079; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+PnFriYR; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=skh4n079; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+PnFriYR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id 64BF66A83A;
	Tue, 28 Apr 2026 11:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777376766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52q44HszTJADk5mgQpBSnp+GeKxyDhOzyyotzJdqZAg=;
	b=skh4n079a3Zo4YorlEMe826SElxmKgQLrV4/CW1Ny/xDQCO7FXBTbGP9FxDSwweUlaqWhx
	DDfpTq7LU1NSC8yrvKYOW8A4+aejJ33q03AKHhmTzElJV9fmK6tYF93+naXXN/iHKo/x4C
	D/nBk40B+rjDEHyVKPng1dLESgu9XlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777376766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52q44HszTJADk5mgQpBSnp+GeKxyDhOzyyotzJdqZAg=;
	b=+PnFriYRAGbrJ0xmesmH3t4Myin+k4eMSILf/VZCN253r5MZex3ZJfxvGb+42Bpsj+GmMJ
	0LJhJkBk0VFZMpAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=skh4n079;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+PnFriYR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777376766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52q44HszTJADk5mgQpBSnp+GeKxyDhOzyyotzJdqZAg=;
	b=skh4n079a3Zo4YorlEMe826SElxmKgQLrV4/CW1Ny/xDQCO7FXBTbGP9FxDSwweUlaqWhx
	DDfpTq7LU1NSC8yrvKYOW8A4+aejJ33q03AKHhmTzElJV9fmK6tYF93+naXXN/iHKo/x4C
	D/nBk40B+rjDEHyVKPng1dLESgu9XlM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777376766;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=52q44HszTJADk5mgQpBSnp+GeKxyDhOzyyotzJdqZAg=;
	b=+PnFriYRAGbrJ0xmesmH3t4Myin+k4eMSILf/VZCN253r5MZex3ZJfxvGb+42Bpsj+GmMJ
	0LJhJkBk0VFZMpAA==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/48] objtool/klp: Fix create_fake_symbols() skipping
 entsize-based sections
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <e10231fce5d8f3f17e4cc7a396a4a8e8d791f994.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <e10231fce5d8f3f17e4cc7a396a4a8e8d791f994.1776916871.git.jpoimboe@kernel.org>
Date: Tue, 28 Apr 2026 13:45:55 +0200
Message-Id: <177737675576.11371.7782607601603321101.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=524; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=J+PDaaj2juRWUDo7k4jbS1nHj8aLRLOR7CH9lbMuJwM=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhswPc7+df2G1dNf8GccnXZl0NqTeN0RQ23JVzabthw/6O
 hbl2JcZdzL6szAwcjBYiimyvN7rLGc4JddAs/rdXZhBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 zxDI0DFi4OIUgKme08H+V9gtvfjItL/vv7Jt+SD+u1or6iD3g95u/mtcXH4TCnIP820q5jv0+AC
 vXOPCTYH7WK7M6J2UvOzT5weNyglrX9c07z/NFiey2+nsl3KDriBbNp92zXmylkfsj6z/4Bbx6Y
 zZqudCDfo9Xm5J3cs7Nl18w1bK+yDueKjq5bupE5n6Frgtjb92ULX+Uqc1l5O8NleC9cxDa9Oel
 7T8EfplNs9MO0Zkx4XTgsl104+ea9/ztdS3o3xTpWvr2y0PNzN1G1hX/xDImnn4lN02Bv5g57N/
 JXpy56ubhb9xF/CxqNm7+29i6XdNGadfBk8W+3i2LPKevHX2isSs81cvqXOEtjtfZWJ4ZlctqC3
 q7mUCAA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.68
X-Spam-Level: *****************
X-Rspamd-Queue-Id: 5D296485151
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2573-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Wed, 22 Apr 2026 21:03:37 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> create_fake_symbols() has two phases: creating symbols from
> ANNOTATE_DATA_SPECIAL entries, and a fallback that uses sh_entsize for
> special sections like .static_call_sites.
> 
> When .discard.annotate_data is absent, the function returns early,
> skipping the entsize fallback and silently allowing unsupported
> module-local static call keys through.
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


