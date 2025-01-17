Return-Path: <live-patching+bounces-1007-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 434E7A1504E
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2025 14:11:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7013B169532
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2025 13:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80FB1FFC74;
	Fri, 17 Jan 2025 13:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="u+l2NRK4";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="G0Cpdy4Q";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Hciih/2T";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="0ho6LH42"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50091FF7CB
	for <live-patching@vger.kernel.org>; Fri, 17 Jan 2025 13:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737119411; cv=none; b=nO7vtzbqJJF/GZ8pm+7sjE1Qzww+HD2vtW91NQ+i281Eg6eXNchHRSz1KI8jxT7StgszEliLuT9pj16g+kEXLbF9xxv6yPVPjDzkY07BqrOBLzyP9+51Cv9fgbrQyN+v5FlFZv+WEVOIeHC8JUFlfSdCRA3Pvbsg7Pb70UNbhLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737119411; c=relaxed/simple;
	bh=YRxQsvsgCt524s1ETEwKxTqwQla3qUVuArv0iASWiAI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=YxUnexDBJWQjaNF085Oi2x2QTIRJjuO5T+Q0GPRZtjqWbezg3qVUNVSvNU3eQMs9uopnpilnH2dlftMcWeT5nJw8L7jS5F74gOXYGc78xepuYWCeZZcdVrX/xfVOsmFsnR17antUTTEb1191vKj18A86Svi3BZx3EEX9wh3SDEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=u+l2NRK4; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=G0Cpdy4Q; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Hciih/2T; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=0ho6LH42; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A514721174;
	Fri, 17 Jan 2025 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1737119408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XaHwtCM2ye1S11j64yLsSa/1AoHYpyt+gzL4bw1NHj4=;
	b=u+l2NRK4QRU6tcZzuDMYK1drQ2Jphg1lFuM9ahy89TMpG3il5nRBc9RnekQH4PSmQtNquh
	c/3XuHeQST5pVtAgto6V792RS37dUIWWipfzT+bGjBf3pzIUBsRwaZqyR5+sGt7FRHtEpJ
	asjfmoDHjbN8uCAfFU5w30ymBYp/S4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1737119408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XaHwtCM2ye1S11j64yLsSa/1AoHYpyt+gzL4bw1NHj4=;
	b=G0Cpdy4Qfsm1Dbk/kEMH/4NoJ87xEe/FxxMoBh29GtbDtZu4y9sgELb3lbFvFsqOpQsBT+
	Eb8evIubibFRG5DQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1737119406; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XaHwtCM2ye1S11j64yLsSa/1AoHYpyt+gzL4bw1NHj4=;
	b=Hciih/2TlsJbHC8Nxr322vrHaF5X618rEOHCjl11DTtvpFl680U3vzFn/w2MwY+9Y29R7e
	AyZcovhFrRSgerOrVABrvaDOGpAD3BpqXE/Cw3wowWlx63sndWz7fvHu5gP6zJsZBl7RyT
	D3QoAmoTL7nMWDvynDOpolwFApO1wE8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1737119406;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XaHwtCM2ye1S11j64yLsSa/1AoHYpyt+gzL4bw1NHj4=;
	b=0ho6LH42XVn6TJyGA9AuAX1Mxr7onx33eaM7QRuSqyGs3dtEMrFFQa0FkypuY+BRskXR8m
	tXHNQvkO/mXbCKBw==
Date: Fri, 17 Jan 2025 14:10:06 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: laokz <laokz@foxmail.com>
cc: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
    Jiri Kosina <jikos@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
    "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: selftests/livepatch: question about dmesg "signaling remaining
 tasks"
In-Reply-To: <tencent_FB39E787D4AB347DE10AE0811A00946EB40A@qq.com>
Message-ID: <alpine.LSU.2.21.2501171407520.6283@pobox.suse.cz>
References: <TYZPR01MB6878934C04B458FA6FEE011CA6192@TYZPR01MB6878.apcprd01.prod.exchangelabs.com> <tencent_D03A5C20BC0603E8D2F936D37C97FAE62607@qq.com> <Z4fa0qCWsef0B_ze@pathway.suse.cz> <tencent_FB39E787D4AB347DE10AE0811A00946EB40A@qq.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.30
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FREEMAIL_TO(0.00)[foxmail.com];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[foxmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Flag: NO
X-Spam-Level: 

Hi,

> > Good question. Have you seen this message when running the selftests,
> > please?
> > 
> > I wonder which test could trigger it. I do not recall any test
> > livepatch where the transition might get blocked for too long.
> > 
> > There is the self test with a blocked transition ("busy target
> > module") but the waiting is stopped much earlier there.
> > 
> > The message probably might get printed when the selftests are
> > called on a huge and very busy system. But then we might get
> > into troubles also with other timeouts. So it would be nice
> > to know more details about when this happens.
> 
> We're trying to port livepatch to RISC-V. In my qemu virt VM in a cloud
> environment, all tests passed except test-syscall.sh. Mostly it complained the
> missed dmesg "signaling remaining tasks". I want to confirm from your experts
> that in theory the failure is expected, or if we could filter out this
> potential dmesg completely.

it might also mean that the implementation on risc-v is not complete yet. 
If there are many unreliable stacktraces, for example, the live patching 
infrastructure would retry many times which causes delays and you might 
run into the message eventually. It pays off to enable dynamic_debug for 
kernel/livepatch/ and see if there is anything suspicious in the output.

Regards,
Miroslav



