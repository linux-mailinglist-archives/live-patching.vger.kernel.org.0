Return-Path: <live-patching+bounces-301-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BEB8D5B4C
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 09:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 18E6AB2640C
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 07:21:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C637C7D3EC;
	Fri, 31 May 2024 07:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="06CD4QJc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QNGDBlmy";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="06CD4QJc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="QNGDBlmy"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F425187569;
	Fri, 31 May 2024 07:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717140067; cv=none; b=e56gB9fuy0F/eBRWG2zXDvuyit7/F81n0RGBk4axBAQ3rsaVm5+HtetvPlRDQkXtvB4cbA2bMUGywEiIcq6GhpHz/UKAkRRZzukbo9yi1UjrCAkjM+U9j5xFf4GILjd5OBVm5ZAKRGlczEablOsjXZs7R0XL6KgDTbh08JTxKGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717140067; c=relaxed/simple;
	bh=WYR+7i4NKLmwsDynggsJJNLVcGwGcGmywKQVHvO9Yig=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=gtXhB0OdIDKdhurJX3YpiXmCDPsFO6uz4FJ0M0aRzXJT0jxLTrV+nOAqhxJWzU6zfu7jec4qVc3Ro3sPtH33bYqIas4zqo7SflbY4d9qMaI39Tdw2LtBH1Bu/SvD5pRRZY03uL0pjjUwDYqmJaw+pnH8nOkg5cTP1CnPyq+pD1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=06CD4QJc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QNGDBlmy; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=06CD4QJc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=QNGDBlmy; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6175121A5C;
	Fri, 31 May 2024 07:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717140063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mME7ND+1fw4Ag9qCWwBXJVKGO9KiVcUzOs9hS3quG9A=;
	b=06CD4QJcoiAlFmY3pOIXXoEB/iSty75+1WbC0oHmoDBUSUKV3rVAHMNdjFOXVOMOYrRYuf
	H/45hV9nC+M8FfgBdE+8l0AaRVl0LzJmY9DRtAHvqOyMIB0F+TLiqdh5ntW0lx6RHDNBk9
	qENIPJhgJvE+pAJVZyuUksKJfqyniiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717140063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mME7ND+1fw4Ag9qCWwBXJVKGO9KiVcUzOs9hS3quG9A=;
	b=QNGDBlmy2dpLwHhipLQA8OCuXl8t2lisB48rOLWk+gU/P4HInZv3ytg8t8fAGcXYQbNjzl
	nKvY98TTMmbAUeAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1717140063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mME7ND+1fw4Ag9qCWwBXJVKGO9KiVcUzOs9hS3quG9A=;
	b=06CD4QJcoiAlFmY3pOIXXoEB/iSty75+1WbC0oHmoDBUSUKV3rVAHMNdjFOXVOMOYrRYuf
	H/45hV9nC+M8FfgBdE+8l0AaRVl0LzJmY9DRtAHvqOyMIB0F+TLiqdh5ntW0lx6RHDNBk9
	qENIPJhgJvE+pAJVZyuUksKJfqyniiA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1717140063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mME7ND+1fw4Ag9qCWwBXJVKGO9KiVcUzOs9hS3quG9A=;
	b=QNGDBlmy2dpLwHhipLQA8OCuXl8t2lisB48rOLWk+gU/P4HInZv3ytg8t8fAGcXYQbNjzl
	nKvY98TTMmbAUeAA==
Date: Fri, 31 May 2024 09:21:02 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: zhang warden <zhangwarden@gmail.com>
cc: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
    Jiri Kosina <jikos@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
    live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
In-Reply-To: <2551BBD9-735E-4D1E-B1AE-F5A3F0C38815@gmail.com>
Message-ID: <alpine.LSU.2.21.2405310918430.8344@pobox.suse.cz>
References: <20240520005826.17281-1-zhangwarden@gmail.com> <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz> <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com> <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz> <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
 <2551BBD9-735E-4D1E-B1AE-F5A3F0C38815@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCPT_COUNT_SEVEN(0.00)[7];
	ARC_NA(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_ZERO(0.00)[0];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_SOME(0.00)[]

Hi,

On Fri, 31 May 2024, zhang warden wrote:

> 
> Hi Bros,
> 
> How about my patch? I do think it is a viable feature to show the state 
> of the patched function. If we add an unlikely branch test before we set 
> the 'called' state, once this function is called, there maybe no 
> negative effect to the performance.

you have not replied to my questions/feedback yet.

Also, I do not think that unlikely changes anything here. It is a simple 
branch after all.

Miroslav

