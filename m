Return-Path: <live-patching+bounces-306-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D7F98D6404
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 16:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DED11C244E7
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 14:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A217B15B118;
	Fri, 31 May 2024 14:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HWU0AKd8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WLnUVKXA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="HWU0AKd8";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="WLnUVKXA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB27B15AAB6;
	Fri, 31 May 2024 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717164411; cv=none; b=dIXYLepo9stGdY9sdQXQnIu+sIkK5cpUKBU/qOnHzHCM0bGodNcaLfMzLuZalKgBTt6KIdV9G3q3B4OmZaZSkLxCPCFJ6Mk9EthSHJZnK6NaPL22vPAQ3ib4MAE+xS6/IAKddToAvzCotfQ+ethtmkvmld8HSwCn79gmP0Wkgrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717164411; c=relaxed/simple;
	bh=B0DkizkCx/fHuPXQz+PWG9GhSLvk9fuZqO3xRqWCRa8=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iYMJvXFQcmyv9VzrqX0c18HQhpYj0bP1ydFwnXHs+OuB9fX1q+XHGqXIl50wMzDxkmn+cskeaJYcu/63oAlGU7fLsSjjRczsKo/1Be51FhCheZB7k+9Qz44/AgTspx/3CYsnfwok0nM2MioME6So+mljC5MUomj6gg+l+jur/xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HWU0AKd8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WLnUVKXA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=HWU0AKd8; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=WLnUVKXA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A64D321C2E;
	Fri, 31 May 2024 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717164407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AO8BLC7Qkg5rQsHrBBnOGJ6JR70Q2hPHi932MvWcJaM=;
	b=HWU0AKd8EnvtjSBqVusMGY5bRvpXFwYCGiqcypc5wCkZzslVnIGgUPbTJQfNQrPz9vQvbm
	Vl5RdOsXSTW0v8ZY0VkMl4/YyoiOjxF4QLuAhbidSUO8C9a7wylQPBDVz1vwJfPkqwHi8R
	g9D5GnEAFCpXv9XJlHc8/Z7RFYV4TB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717164407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AO8BLC7Qkg5rQsHrBBnOGJ6JR70Q2hPHi932MvWcJaM=;
	b=WLnUVKXAunT4ia+0z6CfgQly3KOe6hh13QG+CbJDByQBsjnLV8u4wLNPChnpU0NsIvkpj6
	wq2p0srj1d4272AA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717164407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AO8BLC7Qkg5rQsHrBBnOGJ6JR70Q2hPHi932MvWcJaM=;
	b=HWU0AKd8EnvtjSBqVusMGY5bRvpXFwYCGiqcypc5wCkZzslVnIGgUPbTJQfNQrPz9vQvbm
	Vl5RdOsXSTW0v8ZY0VkMl4/YyoiOjxF4QLuAhbidSUO8C9a7wylQPBDVz1vwJfPkqwHi8R
	g9D5GnEAFCpXv9XJlHc8/Z7RFYV4TB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717164407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AO8BLC7Qkg5rQsHrBBnOGJ6JR70Q2hPHi932MvWcJaM=;
	b=WLnUVKXAunT4ia+0z6CfgQly3KOe6hh13QG+CbJDByQBsjnLV8u4wLNPChnpU0NsIvkpj6
	wq2p0srj1d4272AA==
Date: Fri, 31 May 2024 16:06:46 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: zhang warden <zhangwarden@gmail.com>
cc: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
    Jiri Kosina <jikos@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
    live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
In-Reply-To: <FF8C167F-1B6C-4E7D-81A0-CB34E082ACA5@gmail.com>
Message-ID: <alpine.LSU.2.21.2405311603260.8344@pobox.suse.cz>
References: <20240520005826.17281-1-zhangwarden@gmail.com> <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz> <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com> <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz> <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
 <2551BBD9-735E-4D1E-B1AE-F5A3F0C38815@gmail.com> <alpine.LSU.2.21.2405310918430.8344@pobox.suse.cz> <FF8C167F-1B6C-4E7D-81A0-CB34E082ACA5@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-857398901-1717164406=:8344"
X-Spam-Flag: NO
X-Spam-Score: -2.69
X-Spam-Level: 
X-Spamd-Result: default: False [-2.69 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	CTYPE_MIXED_BOGUS(1.00)[];
	NEURAL_HAM_LONG(-0.39)[-0.394];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[multipart/mixed,text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-857398901-1717164406=:8344
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

> And for the unlikely branch, isn’t the complier will compile this branch 
> into a cold branch that will do no harm to the function performance?

The test (cmp insn or something like that) still needs to be there. Since 
there is only a simple assignment in the branch, the compiler may just 
choose not to have a cold branch in this case. The only difference is in 
which case you would jump here. You can see for yourself (and prove me 
wrong if it comes to it).

Miroslav
--1678380546-857398901-1717164406=:8344--

