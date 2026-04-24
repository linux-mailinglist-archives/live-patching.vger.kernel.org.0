Return-Path: <live-patching+bounces-2510-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IDHdFx4262nRJwAAu9opvQ
	(envelope-from <live-patching+bounces-2510-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:21:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C58C45C16D
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:21:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7CAD630668B9
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 09:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A75386573;
	Fri, 24 Apr 2026 09:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="qjJn4PA3";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="da5LTr+u";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="iiX0kXyy";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5P1zSZX+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917563876B3
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 09:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777022238; cv=none; b=HUvp6fRY8ohUbeaoCJ+IOblx1pZS179J1N8pTzznWyuY8xK3d0ysJcJ/J2TfNMi0BFPui1AJyNqL34IexUSc2EitQ87JNRME24TbRiU5ZJk1yQ4PshJDvVw5TM3QTqKdG/4xYemsUOr6zjTg3vnRp1zdsMt9roBzh5PCJuh2LpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777022238; c=relaxed/simple;
	bh=wERlSyM5Yg+bkQDa+CF7+o4B0f005CAEHb1m8VZdWVQ=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=kZZ/zFZ8yXU+4UH0jEBOBuQONJioBpa8UTaz38fGCLKggHqA7/JIBkRMjzaukgBErT46dCIu2FLEdp8yedjq59wWQld9XIijLRr+fA/Xlylgt3a6gzZ2AqQLIYwf7dJFxv43J40YRjIlOezLyrJaDmOzDZFWpeP9+oudFrqCV9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=qjJn4PA3; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=da5LTr+u; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=iiX0kXyy; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5P1zSZX+; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:2b::1244])
	by smtp-out2.suse.de (Postfix) with ESMTP id 7D5355BD8D;
	Fri, 24 Apr 2026 09:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777022235; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjVZK7Xd/q/wnEcjjBxEdHLWF1DY2YXm2TYrwLqrRIE=;
	b=qjJn4PA3nQeXB5oRB3SAWshfLOj6qIAATdX3HeIcqS1PUFGn96MaZ+VG8aCgrs+ZC6nNt8
	l0iRBNLC3wio5qq4xkpD3KCUqKzCsEoUKUphZ2OCn97q7/wnRoB6Sw34jUJF02xV0v7z3T
	oqOBBOwj58eSs7u8u1PigxG2ipPY9Nc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777022235;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjVZK7Xd/q/wnEcjjBxEdHLWF1DY2YXm2TYrwLqrRIE=;
	b=da5LTr+urC3fbwsOHVWZOITIYaACcG+WmjZM5kMA3yH08y/H8WHl5e+M+vLGiKvvrI7Y8i
	BuoF/BIJy5tZ3xCA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iiX0kXyy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5P1zSZX+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777022233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjVZK7Xd/q/wnEcjjBxEdHLWF1DY2YXm2TYrwLqrRIE=;
	b=iiX0kXyyBEQp8yw3T/MuFTEya/jQrKGsiwzmSsgIpFieO2lfSTCr1iwphZiZnXHOzHkN8P
	v1KjXCZ0gLiqlsayJNpyYjmIatxBbTfsP8TvU/23qlcaLSG9W1s9kmHykVVX52lwnT11eS
	IUHsCwV8/G7xKmsrfI3vQHhW3YYmSn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777022233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xjVZK7Xd/q/wnEcjjBxEdHLWF1DY2YXm2TYrwLqrRIE=;
	b=5P1zSZX+hFVp0p2RN5TSfuRZ9yxjlIKzHGZUCFImbiu6BWN3bJzKa4J1qgUTgVNYH+3AuV
	kMvOKiYKLukqQcDg==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 01/48] objtool/klp: Fix is_uncorrelated_static_local()
 for Clang
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <f2a97da92796708f77c6fb3e07816f84874b79a4.1776916871.git.jpoimboe@kernel.org>
References: <cover.1776916871.git.jpoimboe@kernel.org>
 <f2a97da92796708f77c6fb3e07816f84874b79a4.1776916871.git.jpoimboe@kernel.org>
Date: Fri, 24 Apr 2026 11:17:08 +0200
Message-Id: <177702222839.199199.9363630321712038198.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=589; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=wERlSyM5Yg+bkQDa+CF7+o4B0f005CAEHb1m8VZdWVQ=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhszXpmKVOZ6nJVa4XWhZkb9kVf2jj3vjReOXSd6bvWZh+
 0OBTXsWdTL6szAwcjBYiimyvN7rLGc4JddAs/rdXZhBrEwgU6RFGhiAgIWBLzcxr9RIx0jPVNtQ
 zxDI0DFi4OIUgKmevYX9v9Mzz7d1Rs46npw2Od/zZGZ0aWROmb2ZvfhkbCG/jPUE2ZinwXKvko1
 nT9oR9tXlTxV/fbLaN5cHnI9drmb6fLxpdDnHxPdIvMqHrPkhXC6vlWVkTWT7e7eLVYt+bsnlDI
 mdrczdftJltavgmvPW7Xm2fA+KGw6xcd2vPFGe5fLgz2OeTVJuoby3Lh39H382nGX9Kkmzs5YWm
 c73vfW/cpkFmrOJ1b7nW22ac/2bvHbpUX112w5eC4M/jJlX5eV83dT/r7nzV8n/0cmHAleY7opM
 iNB/sFYyVub0mtDH12QLknXmh3HVCn34uM1Sll0mL3W+gO+03yflasvbL2m2bOTf/CJxqU+61Pf
 LawE=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: +++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 17.40
X-Spam-Level: *****************
X-Rspamd-Queue-Id: 6C58C45C16D
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
	TAGGED_FROM(0.00)[bounces-2510-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Wed, 22 Apr 2026 21:03:29 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> For naming function-local static locals, GCC uses <var>.<id>, e.g.
> __already_done.15, while Clang uses <func>.<var> with optional .<id>,
> e.g. create_worker.__already_done.111
> 
> The existing is_uncorrelated_static_local() check only matches the GCC
> convention where the variable name is a prefix.  Handle both cases by
> checking for a prefix match (GCC) and by checking after the first dot
> separator (Clang).
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


