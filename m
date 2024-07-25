Return-Path: <live-patching+bounces-408-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C563293C1DA
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 14:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 017EC1C20C81
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 12:22:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D11141993BA;
	Thu, 25 Jul 2024 12:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="l6EWr20c";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aDKERetd";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="l6EWr20c";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="aDKERetd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F419199E8B;
	Thu, 25 Jul 2024 12:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721910141; cv=none; b=h/17iti+rIu8apcCmEt4B6VPvYqEeFmWo5HRoHhmnMT/17zjvcI9qx1ewWIjksjtDH5tKx/nCYDxWnSnQFS+zjVTkkf/xsr/VqQl05ulnaZjOpnnwdaWvbVuJSX/1unaRjZgSA3lhZYNvI/rzQjkFicnzRisrDmfuVwogwFkdXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721910141; c=relaxed/simple;
	bh=VsPD0LsmE1Y6Jw6zrWxTzMSAl5UQ5Ce4kykzK4IWn5U=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=j//LhrU5HOT6knJENWn/VljZmDQK/UF4lGuUGreyIspHWZ2CAF4+SVw7eVsKl0CTlfbGBAmvLqaVyB0stCIlqjvNEAZIQ1RZR7nxKklyGtMM8B0CdzLK19lxtfAp9qVcQpJoN8Q4L9xfnS4+U4C51em/2PeoLqVYthA428WlHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=l6EWr20c; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aDKERetd; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=l6EWr20c; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=aDKERetd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3EB2C219E4;
	Thu, 25 Jul 2024 12:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721910138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lh4WXlVukFTl9GHeKFAKh6ubuPXwgy68wcuR6SyAHwQ=;
	b=l6EWr20cJ/6AEWXxqqLBtJhPfz69/pmIpKrNupo+BWcX9HEUopdAWX/tMQw08tkcADwLhz
	6MAOAOlOq5gQHNto4lWCwkv8sansTn3XJCalhbYV41fB72vMakwiMxgN0da9EoCYkJM1bZ
	/rKrxcXCshWZDbdjhVwvUo3TLYXP5LA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721910138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lh4WXlVukFTl9GHeKFAKh6ubuPXwgy68wcuR6SyAHwQ=;
	b=aDKERetdI5P5I5VnzbzhGcTcfjxPinhcFPcYiA4xRG7uQ8+kjT4G0XIRB8vkMIwbfOdrVA
	Y3BOMm8hOQfQkODQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721910138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lh4WXlVukFTl9GHeKFAKh6ubuPXwgy68wcuR6SyAHwQ=;
	b=l6EWr20cJ/6AEWXxqqLBtJhPfz69/pmIpKrNupo+BWcX9HEUopdAWX/tMQw08tkcADwLhz
	6MAOAOlOq5gQHNto4lWCwkv8sansTn3XJCalhbYV41fB72vMakwiMxgN0da9EoCYkJM1bZ
	/rKrxcXCshWZDbdjhVwvUo3TLYXP5LA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721910138;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lh4WXlVukFTl9GHeKFAKh6ubuPXwgy68wcuR6SyAHwQ=;
	b=aDKERetdI5P5I5VnzbzhGcTcfjxPinhcFPcYiA4xRG7uQ8+kjT4G0XIRB8vkMIwbfOdrVA
	Y3BOMm8hOQfQkODQ==
Date: Thu, 25 Jul 2024 14:22:18 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Petr Mladek <pmladek@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, 
    Joe Lawrence <joe.lawrence@redhat.com>, Nicolai Stange <nstange@suse.de>, 
    live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [POC 5/7] livepatch: Convert klp module callbacks tests into
 livepatch module tests
In-Reply-To: <20231110170428.6664-6-pmladek@suse.com>
Message-ID: <alpine.LSU.2.21.2407251411300.21729@pobox.suse.cz>
References: <20231110170428.6664-1-pmladek@suse.com> <20231110170428.6664-6-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-4.10 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.10

> diff --git a/lib/livepatch/test_klp_speaker.c b/lib/livepatch/test_klp_speaker.c
> index d2d31072639a..d8e42267f5cd 100644
> --- a/lib/livepatch/test_klp_speaker.c
> +++ b/lib/livepatch/test_klp_speaker.c
> @@ -9,23 +9,174 @@
>  
>  #include <linux/module.h>
>  #include <linux/printk.h>
> +#include <linux/delay.h>
> +#include <linux/sysfs.h>
> +
> +#include "test_klp_speaker.h"

the header file does not exist.

As you mentioned, it would definitely help if you managed to split the 
patch somehow.

Miroslav

