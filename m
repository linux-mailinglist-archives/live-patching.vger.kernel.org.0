Return-Path: <live-patching+bounces-2513-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FFUM5Q562nRJwAAu9opvQ
	(envelope-from <live-patching+bounces-2513-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:36:20 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A3F045C48F
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:36:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58BA8300B9D8
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 09:34:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019F13890EE;
	Fri, 24 Apr 2026 09:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="nuYW8vMz";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="tanhMwXi";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ZuCwW8id";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="hQKn8CeR"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A505636E48E
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 09:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777023276; cv=none; b=CYHrcNWUmyQ2GIBmJ0WXyEumifjZgiUCwtgu6zeESVgC/C27SE6yIq377zYHiVv4wfDYdSzEdsyAxUTDriXp50EpkinljMGY48J+OaWHi4mDO+8Cpp+qXcbjzXDnbMnihCq8Z7YMegT0E+JwwXmp2m9ijV7JUOLWjxH1pM72bBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777023276; c=relaxed/simple;
	bh=2b3PJRV2CkOwftDFfLmm8h0ktUikNyNZLRElsGzSqYY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=h9W0C4aoTphRJycePJwMkxw81u9grtAKG0/8vvMwXTknXpl2qspCi9+IJ5UjgSC4398GbMK/fJSFso85oz8Ds1xxnopRrAgTYoe6hwwgY837iEeVDubSKYb74FTdkVwZ/bsduM2nlypkXdxTmtiuXRK7HReVJX5TUksZEsKVbJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=nuYW8vMz; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=tanhMwXi; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ZuCwW8id; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=hQKn8CeR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D08B96A8A3;
	Fri, 24 Apr 2026 09:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777023274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qiWy/fBSzLbXqTTr8b7wqX9I/K2R0GLZ+CbuL/uSI5s=;
	b=nuYW8vMzAE92MpmMegn3o3yDFmis+uYEBgmhYMEluGaUshiQe6/2dzA/SekzxBje86tIFr
	4rF1MXdFsyCHuOHJtnaux9DrIn/dUWfIF4JYd+vp41oHqjssVzNtWhtesvs1GpSkTW/msN
	1kj5srS67dJyeeX3/RVJxeClo8aERB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777023274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qiWy/fBSzLbXqTTr8b7wqX9I/K2R0GLZ+CbuL/uSI5s=;
	b=tanhMwXipxu9hSSwU4BHI7sSOmLxzcAWPTXSwINjZ0N9+hlzb4/V3IsSZ8JxoVyKglv9rs
	jG+ID5BcCCq9JmAg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777023273; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qiWy/fBSzLbXqTTr8b7wqX9I/K2R0GLZ+CbuL/uSI5s=;
	b=ZuCwW8id/mA18pD8xJ7pVnylnxLDmCyrJfCAFZ9oBK98H7hZcuuVerJ7ZK2OcCMcVDZzu2
	OuQNU0ZEMVZE7ESPu+8Y7w5fx9ID6/MRpe3d8k+2vr5VPPpW1XPFPhbKyOr9ZwgUfwx6bh
	EbBwquwMb7G7Tn81tWAgWQ76pMU0ONo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777023273;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qiWy/fBSzLbXqTTr8b7wqX9I/K2R0GLZ+CbuL/uSI5s=;
	b=hQKn8CeRVzGf0HOKa5lmf/4uJiHX08T+uXfBNhGIs+w/XVeuORe3sT4xGdLv7V5Vdolskp
	eItOa9tuMwrRNUAg==
Date: Fri, 24 Apr 2026 11:34:33 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
    live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
    Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 03/48] objtool/klp: Don't correlate __ADDRESSABLE()
 symbols
In-Reply-To: <177702262868.199199.17632749620515020845.b4-review@b4>
Message-ID: <alpine.LSU.2.21.2604241133330.25696@pobox.suse.cz>
References: <cover.1776916871.git.jpoimboe@kernel.org> <ea9af1b6136e9aa11589e592d0fc59e4ef414579.1776916871.git.jpoimboe@kernel.org> <177702262868.199199.17632749620515020845.b4-review@b4>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.28
X-Spam-Level: 
X-Rspamd-Queue-Id: 5A3F045C48F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2513-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email,pobox.suse.cz:mid]

On Fri, 24 Apr 2026, Miroslav Benes wrote:

> On Wed, 22 Apr 2026 21:03:31 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > Symbols created by __ADDRESSABLE() are only used to convince the
> > toolchain not to optimize out the referenced symbol.
> 
> Reviewed-by: Miroslav Benes <mbenes@suse.cz>

Looking at it again... wouldn't it be better to address this in 
is_special_section() which is looking at .discard.addressable already 
(only the outcome is different)?

Miroslav

