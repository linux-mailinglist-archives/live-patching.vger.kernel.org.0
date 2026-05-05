Return-Path: <live-patching+bounces-2723-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mMqeNc3Z+WnNEgMAu9opvQ
	(envelope-from <live-patching+bounces-2723-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:51:41 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D08544CD01F
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:51:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DA6C230377E8
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E28203845B6;
	Tue,  5 May 2026 11:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="atueTEpe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N4Pb2Z99";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="atueTEpe";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="N4Pb2Z99"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70A9392802
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777981430; cv=none; b=Av+nHIxdsvofJguQ4aBaUpJPdLKlrtqujY4VdJCpnx5VHtLr5wmdG/PVjcsrEnDx3fX/ZaAeofeOAM+X+Qwj2oDpm0H4doGTNdPtsnRjYpQc+tD0SgDbd3hICaVE5ewIap6uq0NnwGMjPv4f5svD8LxP954A48gsyihZQxOmRbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777981430; c=relaxed/simple;
	bh=usAblITCg9lFMsKoM5kud9iBmKS15GS3ifGxhqXQ5AQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=HQWbty7ddGAHOivCJs2EBm3ByT1WgRjskov6nf8VN4m9cDqhVAT4qo2MFyFAfqzL0ZXxA8MNB6eFPJi5j4IsBya1Sh5Qkv7wjc9P8M9LzrVxZpcJkjwqaRaB6FI7MUa76ibIrON7g1602UhfdNR5sZ0+8ED2RVOg230Ysor+atQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=atueTEpe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N4Pb2Z99; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=atueTEpe; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=N4Pb2Z99; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id ADBEB5C2D0;
	Tue,  5 May 2026 11:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777981420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIj5uUszH2BrIuIQXr+I3kJoyXjVJWIh/8R1+7ALBrc=;
	b=atueTEpeMh3Pv/aEA01JNfq/1EYOCKcbmcD4HNlwocQjI30rz5mHyGsaD3c1nazykgc2KB
	qiaBd8SgTEvhfEV3Op1WIR8Btp0zZxO5Sl6j2h1JBIrggxMAysg5RHJcVPhSjrQpptzl+e
	P91T3xo5vRyv3OXu3jZV5VYOzv1PjQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777981420;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIj5uUszH2BrIuIQXr+I3kJoyXjVJWIh/8R1+7ALBrc=;
	b=N4Pb2Z99GAJ251bP6FRojZR1wZj7zFtYh6lr3Wffjm6i7JauAQn4Sn8ivr1TKi3tv9sfqT
	oflqLTLcFAw4E2DA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=atueTEpe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=N4Pb2Z99
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777981420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIj5uUszH2BrIuIQXr+I3kJoyXjVJWIh/8R1+7ALBrc=;
	b=atueTEpeMh3Pv/aEA01JNfq/1EYOCKcbmcD4HNlwocQjI30rz5mHyGsaD3c1nazykgc2KB
	qiaBd8SgTEvhfEV3Op1WIR8Btp0zZxO5Sl6j2h1JBIrggxMAysg5RHJcVPhSjrQpptzl+e
	P91T3xo5vRyv3OXu3jZV5VYOzv1PjQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777981420;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fIj5uUszH2BrIuIQXr+I3kJoyXjVJWIh/8R1+7ALBrc=;
	b=N4Pb2Z99GAJ251bP6FRojZR1wZj7zFtYh6lr3Wffjm6i7JauAQn4Sn8ivr1TKi3tv9sfqT
	oflqLTLcFAw4E2DA==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 40/53] objtool: Consolidate file decoding into
 decode_file()
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <36478f25bee19c8acbff3992e27436b544c4e26b.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <36478f25bee19c8acbff3992e27436b544c4e26b.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:43:37 +0200
Message-Id: <177798141795.9921.425193304582000754.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=557; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=usAblITCg9lFMsKoM5kud9iBmKS15GS3ifGxhqXQ5AQ=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhsyf19/kZB9dVZI/J8t30xGu9Bv7Xb61xsidsrggkZtV1
 pRp9f1sJ6M/CwMjB4OlmCLL673OcoZTcg00q9/dhRnEygQyRVqkgQEIWBj4chPzSo10jPRMtQ31
 DIEMHSMGLk4BmOqa3ey/mBOjr/Uwz+vofzj/sRDHzIjz9+wlVkqJz5I+uf7iuYZtjt2zz89Z0uH
 G+OfJ4if39tSfuH3WYUvQ20lz05mPTIi50SKow8WUeEOn/rglj7zHtOSqot3ZAQEKyzk/JlzqOn
 Fi/72JYYV7imuFr5RvbdBs1DWd91tpR8rM1VFJs472OUXWcc0U28GuPWPp2QOdefs/2YiIX474p
 n7qbw7/jO3rj3voT3SL9iiOfb1OfX0Y35IXspqBW3YVFMk93s7OFsQuvUdkjRCbQODEzPU3ollz
 HB12rysyV/rzkTv2YJW7Yo9xUPXf6btjzd+frYz29Hdg6c3m7Ov7UjknhN/w/dKFggbbsl98rUt
 b3lsAAA==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.39
X-Spam-Level: ********************
X-Rspamd-Queue-Id: D08544CD01F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2723-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.968];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:28 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> decode_sections() relies on CFI and cfi_hash initialization done
> separately in check(), making it unusable outside of check().
> 
> Consolidate the initialization into decode_sections() and rename it to
> decode_file(), and make it global along with free_insns() and
> insn_reloc() for use by other objtool components -- namely, the checksum
> code which will be moving to another file.
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


