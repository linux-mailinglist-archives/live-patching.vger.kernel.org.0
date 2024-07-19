Return-Path: <live-patching+bounces-399-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C75E93777A
	for <lists+live-patching@lfdr.de>; Fri, 19 Jul 2024 14:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADFF8282DCC
	for <lists+live-patching@lfdr.de>; Fri, 19 Jul 2024 12:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC9012BF23;
	Fri, 19 Jul 2024 12:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kN14tMqx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7zbOd1FJ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kN14tMqx";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="7zbOd1FJ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAAF74079;
	Fri, 19 Jul 2024 12:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721390956; cv=none; b=lxc7msc64O3Icmt2++8jccWbO+dbe66rki/MeDITmhXHt6PaJFJyAKc0N17gQsR1Ka2x1vOw2OyvUP6G7BeZbDLSY2Q6QGH6Yc5W0CU57HOAqijNBActws+HNCBdW790V/kOt++CICwCFw2kcmXGMBiu6xzT6gG0mmZ/Owvx7ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721390956; c=relaxed/simple;
	bh=CYV2z6Q/85scKVZz7dr0FuYLydleiVFslUtVWQu1Jns=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=UPswf42fW0QqekoyScxFPNVoiVoPvg2AW05n5uN+w6CCvViZzCy+PQDheP7geg4bqtJ3daekDMQuJ9ygzUKz44WAZ8CuXhmKfGEN7k9CdHgfUDt3re+1s0eShaSip2wFqPNWAa6ZPjrACf3V69NVMlug6NRSvyK0zNCUP6t+u+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kN14tMqx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7zbOd1FJ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kN14tMqx; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=7zbOd1FJ; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0146E21262;
	Fri, 19 Jul 2024 12:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721390953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11PluLzy6ppeFbL1L3whlVEgm7pRH3TP7XHYr44hdc4=;
	b=kN14tMqxopV1ttFfuXizxnU1/TnJ0tyn6Y/M12NkFI+iM9HoAAfFlzJCMnXOEmxv5fF9ga
	Sy/mU8UhparbVx34o1EwWBAI/nggl6uT322EU+PU3oPwjRuMa/WBnscN6oIQ/zJpafzXMR
	0DJc7JhJ6TsNNkA3XVZvUOhVE55WhPU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721390953;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11PluLzy6ppeFbL1L3whlVEgm7pRH3TP7XHYr44hdc4=;
	b=7zbOd1FJKLsBV+xT/Gr3GsQek9mko6QMO1B3ZW3cw5UkyIE3yGR+43NiMzFI8hV+ByiW0a
	6Z3bGCTiCCXdPJBg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1721390953; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11PluLzy6ppeFbL1L3whlVEgm7pRH3TP7XHYr44hdc4=;
	b=kN14tMqxopV1ttFfuXizxnU1/TnJ0tyn6Y/M12NkFI+iM9HoAAfFlzJCMnXOEmxv5fF9ga
	Sy/mU8UhparbVx34o1EwWBAI/nggl6uT322EU+PU3oPwjRuMa/WBnscN6oIQ/zJpafzXMR
	0DJc7JhJ6TsNNkA3XVZvUOhVE55WhPU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1721390953;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=11PluLzy6ppeFbL1L3whlVEgm7pRH3TP7XHYr44hdc4=;
	b=7zbOd1FJKLsBV+xT/Gr3GsQek9mko6QMO1B3ZW3cw5UkyIE3yGR+43NiMzFI8hV+ByiW0a
	6Z3bGCTiCCXdPJBg==
Date: Fri, 19 Jul 2024 14:09:12 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: "zhangyongde.zyd" <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Add using attribute to klp_func for using
 func show
In-Reply-To: <20240718152807.92422-1-zhangyongde.zyd@alibaba-inc.com>
Message-ID: <alpine.LSU.2.21.2407191402500.24282@pobox.suse.cz>
References: <20240718152807.92422-1-zhangyongde.zyd@alibaba-inc.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.992];
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
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

Hi,

On Thu, 18 Jul 2024, zhangyongde.zyd wrote:

> From: Wardenjohn <zhangwarden@gmail.com>
> 
> One system may contains more than one livepatch module. We can see
> which patch is enabled. If some patches applied to one system
> modifing the same function, livepatch will use the function enabled
> on top of the function stack. However, we can not excatly know
> which function of which patch is now enabling.
> 
> This patch introduce one sysfs attribute of "using" to klp_func.
> For example, if there are serval patches  make changes to function
> "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
> With this attribute, we can easily know the version enabling belongs
> to which patch.
> 
> cat /sys/kernel/livepatch/<patch1>/<object1>/<function1,sympos>/using -> 0
> means that the function1 of patch1 is disabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> 1
> means that the function1 of patchN is enabled.

is this always correct though? See the logic in klp_ftrace_handler(). If 
there is a transition running, it is a little bit more complicated.

Miroslav

