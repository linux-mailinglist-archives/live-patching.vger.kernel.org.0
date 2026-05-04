Return-Path: <live-patching+bounces-2695-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +G+KMNun+GlexgIAu9opvQ
	(envelope-from <live-patching+bounces-2695-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 16:06:19 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B0C4BE857
	for <lists+live-patching@lfdr.de>; Mon, 04 May 2026 16:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 56032301386D
	for <lists+live-patching@lfdr.de>; Mon,  4 May 2026 14:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900073DE422;
	Mon,  4 May 2026 14:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EvKiPITX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HOabHoxo";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EvKiPITX";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="HOabHoxo"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EBA3D9029
	for <live-patching@vger.kernel.org>; Mon,  4 May 2026 14:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903501; cv=none; b=F+dPxYYutoUpEljzVQyxDHhOPAkce7CJdukpx+kBu7lkpibSzuvOmKHGCPGIUDOhzAODtGrg1JL5rOucf4H0L6D7c1OqHXdJi6d1mkXLYpml6Hgxx/6g/hDlF/hFpoRuGP4nU5WSTEbK9K5nghk0X590XMjvn8eAW7Vztx4saRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903501; c=relaxed/simple;
	bh=o78SBQ3touE0EUJZhw8Q6FqZsKvPb1SPqtofTIJ3lOs=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=TLZfMjvgmBq4kF6o8ojlkEHfEXA8g7gfBkEPvnYE/0J9BHSgnPHGgCy2UheZIQQA5jk4XsHp3gu4Tkez9Tm92wg8ylwQPubnLkyG69IYY5ZtPDp8CBlSsnF03dTdgNKw88hUiSf8YheyLy4S2GizY2C3RF0GVY6Qbf7P2gSl3hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EvKiPITX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HOabHoxo; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EvKiPITX; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=HOabHoxo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:2b::1244])
	by smtp-out1.suse.de (Postfix) with ESMTP id 16F496B280;
	Mon,  4 May 2026 14:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777903498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNcabpgwNA4CTMaZLBBtZzOuguwPNg/56iGd5dwxkZ4=;
	b=EvKiPITXD+5RXXMG6BEKvBdeseLSI0J3jteFV3LF+6h011oAYKL+PFiGuiN/ZCbJsHZW7Y
	9IHrq27qfOmJl0GRwf2OH62Fvhc9E02aDCvNcUgAip6o4FIKGuUD7XxOCwErV6zkSFNPwj
	nPEN3SvVIAuZ/bFQcRvL2Jobp0dz5+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777903498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNcabpgwNA4CTMaZLBBtZzOuguwPNg/56iGd5dwxkZ4=;
	b=HOabHoxorDgaSoyqX5sDnQ8eC27BJmBCnPn1HMFrsggMnsIG/QJFFCx8str4Sjcis5V71t
	wdZ9VcNEu9uuzDBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EvKiPITX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HOabHoxo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777903498; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNcabpgwNA4CTMaZLBBtZzOuguwPNg/56iGd5dwxkZ4=;
	b=EvKiPITXD+5RXXMG6BEKvBdeseLSI0J3jteFV3LF+6h011oAYKL+PFiGuiN/ZCbJsHZW7Y
	9IHrq27qfOmJl0GRwf2OH62Fvhc9E02aDCvNcUgAip6o4FIKGuUD7XxOCwErV6zkSFNPwj
	nPEN3SvVIAuZ/bFQcRvL2Jobp0dz5+4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777903498;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oNcabpgwNA4CTMaZLBBtZzOuguwPNg/56iGd5dwxkZ4=;
	b=HOabHoxorDgaSoyqX5sDnQ8eC27BJmBCnPn1HMFrsggMnsIG/QJFFCx8str4Sjcis5V71t
	wdZ9VcNEu9uuzDBQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 10/53] objtool/klp: Fix --debug-checksum for
 duplicate symbol names
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <83781c62e85a35d641b7d793b133195e3a4abba7.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <83781c62e85a35d641b7d793b133195e3a4abba7.1777575752.git.jpoimboe@kernel.org>
Date: Mon, 04 May 2026 15:04:53 +0100
Message-Id: <177790349307.43444.4180539163930180199.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=393; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=o78SBQ3touE0EUJZhw8Q6FqZsKvPb1SPqtofTIJ3lOs=;
 b=owGbwMvMwMHYWJt9x2W1tA7jabUkhswfy9usa44/snFZd+5W2Z3fN3pvMywOzvzd4J6beOvkL
 1H5y9PsOxn9WRgYORgsxRRZXu91ljOckmugWf3uLswgViaQKdIiDQxAwMLAl5uYV2qkY6Rnqm2o
 Zwhk6BgxcHEKwFQzuLD/07mhcHB1q1pq32LbRqfiBmbflOgygXCeDz/8POt+fDMT+dNwVqXq4oz
 Uyj2CXU/26sTzhWe5bWbo6Lk/3aPtLqNsisfVt/cZz2+Zfnv2RrELHHeClT9wzRX7YBPYnLpBNj
 i308alMvXw3TDNk8ud7+yW0E6Mk3R7d9F22ZfkmaeY0h2zMi9fem45Rem9yH1pWYWgq+YXUytY4
 5d4Ktz+/ste7YWUuNt/BXbl5Uuymw3Or0jUN70SdN16ypr1M4/vnnOmN+TMDAPBpOlpkWKbV695
 Om++r8inkh1/vuzeYDozYkZv6q6vkXPOxl7byx24xPH+2u6nM64f3bL42tqq/Vf/z5B4e+Z3770
 HIWoxuwA=
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.39
X-Spam-Level: ********************
X-Rspamd-Queue-Id: 62B0C4BE857
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2695-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.969];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]

On Thu, 30 Apr 2026 21:07:58 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> find_symbol_by_name() only returns the first match, so
> --debug-checksum=<func> silently ignores any subsequent duplicately
> named functions after the first.
> 
> Fix that, along with a new for_each_sym_by_name() helper.
> 
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


