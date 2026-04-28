Return-Path: <live-patching+bounces-2580-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKa7HfWt8GnOWwEAu9opvQ
	(envelope-from <live-patching+bounces-2580-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 14:54:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C647948530D
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 14:54:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 019E3311E8E1
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 12:47:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01D3844CACB;
	Tue, 28 Apr 2026 12:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pGUVQKl2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+p8JqZVv";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="pGUVQKl2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+p8JqZVv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7BF43D4F7
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 12:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777380245; cv=none; b=SUpml+WVLU//JenS/6UOM1bdUImkZaW9m/GxvLpjA1c9x4jgJfiE8iXBi/MSoEtxypFCsyaVxjxsdALx5eEQiZzEKZKy6wViC3UwhakTUqJGiylhKhVbsv1TCtPDLUdcCzjF2QrzrCKEqVt9kBuvksB9mvuDhxxXJMvreL2Y3No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777380245; c=relaxed/simple;
	bh=CcaEEf3raQ+8G3ikImRZLsiI8/I6/iYU3E/vFI6Tiik=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=dcasEbCqCHZ8kGRhBte+AZD1ad0LlJYGdIIyf51SiYJHE4As0F2XdTwph6T6iTziYEktlokHBPILAfwpiL1RYWn0CJjjOCe93VDT545vZEytqOZDZsu4QSfN/wa/N2xXuee2XJOtz58JqLmIirrkYMhyqQJw0ACQSFYPwq0QWJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pGUVQKl2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+p8JqZVv; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=pGUVQKl2; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+p8JqZVv; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out1.suse.de (Postfix) with ESMTP id 6552B6A881;
	Tue, 28 Apr 2026 12:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777380180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y20POoP6V/cvXv8TWrMLc589N6UcfTk9Gsh8wUwAa3Q=;
	b=pGUVQKl2ofIBBJNt/TjkNsfUXjOuj/FoengPRYex4e7AClMlG11/DNtLS0TqgL1b58cfSa
	YA0cdeW4NjSxmZ1ewUE6x1fxLhrwjk1cHYJHV+yR7AuhfkTxxBrPjTtP1rQiRviZgjM2w/
	q4Ce+5WzqN9XQSyPRaf5JEn64XZLP7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777380180;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y20POoP6V/cvXv8TWrMLc589N6UcfTk9Gsh8wUwAa3Q=;
	b=+p8JqZVvp/fOH7WI70aX9qml7foQHAS3XBFATEApSHf3r473+tBAte/DRkLCoWNK9KyeOX
	dzowZP7yeca/y6CA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pGUVQKl2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+p8JqZVv
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777380180; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y20POoP6V/cvXv8TWrMLc589N6UcfTk9Gsh8wUwAa3Q=;
	b=pGUVQKl2ofIBBJNt/TjkNsfUXjOuj/FoengPRYex4e7AClMlG11/DNtLS0TqgL1b58cfSa
	YA0cdeW4NjSxmZ1ewUE6x1fxLhrwjk1cHYJHV+yR7AuhfkTxxBrPjTtP1rQiRviZgjM2w/
	q4Ce+5WzqN9XQSyPRaf5JEn64XZLP7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777380180;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y20POoP6V/cvXv8TWrMLc589N6UcfTk9Gsh8wUwAa3Q=;
	b=+p8JqZVvp/fOH7WI70aX9qml7foQHAS3XBFATEApSHf3r473+tBAte/DRkLCoWNK9KyeOX
	dzowZP7yeca/y6CA==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 16/48] objtool/klp: Fix relocation conversion failures
 for R_X86_64_NONE
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <2779114efd74a9dd9f1e78076e1b9e3a5273de73.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <2779114efd74a9dd9f1e78076e1b9e3a5273de73.1776916871.git.jpoimboe@kernel.org>
Date: Tue, 28 Apr 2026 14:42:55 +0200
Message-Id: <177738017547.11371.14673493009732344391.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=495; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=CcaEEf3raQ+8G3ikImRZLsiI8/I6/iYU3E/vFI6Tiik=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhswPq4NmNGvt4hSOW5HN5Vu3wdmjc1OQ0dwX8V62nYqMN
 VtO2/zpZPRnYWDkYLAUU2R5vddZznBKroFm9bu7MINYmUCmSIs0MAABCwNfbmJeqZGOkZ6ptqGe
 IZChY8TAxSkAU91TwMHQH6iynGmGjKpb6Mk9bgppMx2n6xvu0G2+Vu7uvOfg1rztm6KlJhk/OKM
 wW8Zlw/WnJ5j3BavUzQysOHtA44hVWVvwqY1vdFY2nb0Vsi7v/6rC+Ek32Gb/PVz2d1ffvS83c3
 s7nMQXfp9dwNk2c07K+ZuVIvM4/pzbUCjY8PVO5YY3u4Vk37AY7G2/UKYWFWTm8vibUV2XrVZb5
 OImrTKru78NTry6djYp2fsnFze/ceG2h5pWP6/NmLn2aJ9HYMfpHcmzXmXvOy9pyxT/+fQXPt/f
 17cVfjr9wfP9R4YG8bc34yrfSn/kf5T4RvU0Fx9DdkaTWKP5oWvrilcH660WlzlSN+X18p3qFR2
 Gt7JCAA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.69
X-Spam-Level: ********************
X-Rspamd-Queue-Id: C647948530D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2580-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,suse.cz:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Wed, 22 Apr 2026 21:03:44 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Objtool has some hacks which NOP out certain calls/jumps and replace
> their relocations with R_X86_64_NONE.  The klp-diff relocation
> extraction code will error out when trying to copy these relocations due
> to their negative addend, which would only makes sense for a PC-relative
> branch instruction.  Just ignore them.
> 
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


