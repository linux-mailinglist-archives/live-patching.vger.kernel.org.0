Return-Path: <live-patching+bounces-2712-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OLDLBUHW+WmDEgMAu9opvQ
	(envelope-from <live-patching+bounces-2712-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:36:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 84DAD4CCC3E
	for <lists+live-patching@lfdr.de>; Tue, 05 May 2026 13:36:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 82536308656C
	for <lists+live-patching@lfdr.de>; Tue,  5 May 2026 11:27:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5B693BE168;
	Tue,  5 May 2026 11:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kTkXZei1";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="M/ljggzm";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="BDQh1AxA";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="uie93smY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFDB3845D4
	for <live-patching@vger.kernel.org>; Tue,  5 May 2026 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777980413; cv=none; b=RZrB9L7avJSdSYz9AlQSMH5iOiATQLBEDh4TzHnBUlVcE5yOSteOinBEgAWiTHLMWCzIUJarjRs3pdriIeKM8qKf1ga/VSfPgihzbIhKKnrDLgHzKoFtn5+96NfNb43+eas5ceiaI30Exdc+8ukAHAT0+glTErvpWw0sK4r7U1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777980413; c=relaxed/simple;
	bh=W8FuESPyKpY5IvsitNWFeYhWJM2ir7nQiV66zjn2xuM=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=A3uCwLW1Sy/ezAF+iukv+xgTpf/htDAqnMQyO4IeS4keT6CRM5nvjMnkeCCIQKqCF4Jhf9mLmtvp737LzUBegrG+FUb+sC2K2X+St5cNlCNelL8HjeKzCozA7t267xC00+N5vyhx7cHeU5ve5grbrqkVWA1QYM8Q3GiJtt8906w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kTkXZei1; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=M/ljggzm; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=BDQh1AxA; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=uie93smY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from localhost.localdomain (unknown [IPv6:2a07:de40:b2bf:1b::12ef])
	by smtp-out2.suse.de (Postfix) with ESMTP id E88985CB63;
	Tue,  5 May 2026 11:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980397; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zv6dV3urEfZh51/e7R1oS2CyGXc6bY8mQ257L+GOI8E=;
	b=kTkXZei1ENkzXBcR25zE7afMsTr+NZp0h0rQOC4YZ6VhS1ho1XjAVpExCyph21BhocPHMI
	0kwlAscXTdMo/MPyctLFj4p3pMtOLyYx3FPK2OGt348QUcC0yj9CWYe94dWw0tLlFIPSlv
	pQctcFwEu7DrSiC/ymAFFYHPVxvde+Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980397;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zv6dV3urEfZh51/e7R1oS2CyGXc6bY8mQ257L+GOI8E=;
	b=M/ljggzmwFnjpMtwWUpH+LddlRQq5vvz8NOd5iKMMQDNk7EYHNcWOfomk3B37mL1PBnq2M
	Xb2guMgzWFk4/yAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BDQh1AxA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uie93smY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777980396; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zv6dV3urEfZh51/e7R1oS2CyGXc6bY8mQ257L+GOI8E=;
	b=BDQh1AxADdXr4Gcxtt0S4hDhVDLfMLSy3sIPddnpgkD+vC9TYIRteZiZ1RlF2HUwJqKs4u
	Xaln3mpEXdiXNuz/gICBTUVNStpo9qRa7S1zIzlPxYzWS2mCIem5DY4Dq6enzy6yoq7jBK
	8OdjaYNVPxNQp+5cH6eo1IIVKrwkods=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777980396;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zv6dV3urEfZh51/e7R1oS2CyGXc6bY8mQ257L+GOI8E=;
	b=uie93smYQhegXIZc1c1kfOd3SnbiHzVQNGR85JPT95ir+ysMZPIUTRTIBC1M0mDLAF0HgP
	sauH1ncQlgiSRMAQ==
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 36/53] objtool/klp: Handle Clang .data..Lanon
 anonymous data sections
From: Miroslav Benes <mbenes@suse.cz>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
 live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
 Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
In-Reply-To: <a51923df411316860fd18a0db85fdf465d36ddb0.1777575752.git.jpoimboe@kernel.org>
References: <cover.1777575752.git.jpoimboe@kernel.org>
 <a51923df411316860fd18a0db85fdf465d36ddb0.1777575752.git.jpoimboe@kernel.org>
Date: Tue, 05 May 2026 13:26:30 +0200
Message-Id: <177798039059.9921.14573492617438474398.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=468; i=mbenes@suse.cz;
 h=from:subject:message-id; bh=W8FuESPyKpY5IvsitNWFeYhWJM2ir7nQiV66zjn2xuM=;
 b=owEBiQF2/pANAwAIAYF9a9xEqxssAcsmYgBp+dPsroxffJk2nLbtb7365QRT1ZeilG42oVGOu
 eRVWezxJl+JAU8EAAEIADkWIQTrvUMeMZRtMCl77t2BfWvcRKsbLAUCafnT7BsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMiwyLDIACgkQgX1r3ESrGyybgwf/eWroax8qtqQaCYa+5gaJxzcuoUQIdr6
 iRovd/PJshpxtbsT8tRlJ2BaPc/YJ7fEz24mcZ7+wIDmczX9npRIDzHfaRQlZSV5FSqWcMBzYpa
 1KjqHZrHDnYVaV0aJ0JE0pcimhQm1m2rAVy12onffzUA2m+c+YLcY+sPpGmxwAZmH6naTkozMxC
 8py8E+4yX4M3tzGFXj/jpvb4V4H402EZspTD+qhbm86oVCPZ9fyuhvTu4kqxgsCjMcjEQuWlS7A
 Og/V00MnDvQn5csNulvHKnir1ac69fahMuUsyjEEj/rEvX0EypS/UJwoL9g3w49ZzmXrfZYy+Zq
 pq1El40dXqw==
X-Developer-Key: i=mbenes@suse.cz; a=openpgp;
 fpr=91BB0699882EF39D46654BB3FF98A38DA80834DA
X-Spamd-Bar: ++++++++++++++++++++
X-Spam-Flag: YES
X-Spam-Score: 20.83
X-Spam-Level: ********************
X-Rspamd-Queue-Id: 84DAD4CCC3E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	SPAM_FLAG(5.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
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
	TAGGED_FROM(0.00)[bounces-2712-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.cz:+];
	NEURAL_HAM(-0.00)[-0.969];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.cz:dkim,suse.cz:email]

On Thu, 30 Apr 2026 21:08:24 -0700, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> Clang generates anonymous data sections named .data..Lanon.<hash>.
> These need section-symbol references in the same way as .data..Lubsan
> (GCC) and .data..L__unnamed_ (Clang UBSAN) sections.  Without this,
> convert_reloc_sym() fails when processing relocations that reference
> these sections.
> 
> 
> [...]

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

-- 
Miroslav


