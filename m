Return-Path: <live-patching+bounces-277-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42DA58C98FE
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 08:46:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F193E2811B7
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 06:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93480168DE;
	Mon, 20 May 2024 06:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k8oIx/nh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vmqTbn1b";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="k8oIx/nh";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="vmqTbn1b"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE80BA47;
	Mon, 20 May 2024 06:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716187589; cv=none; b=K5FjInNpRklTWe99namWnWh2ZNYOL6sHvbCMaX1N4ppcv83fNkxxdnZzGrxX6QJ1aoONNo9nN8rftWGk1g02UE1XzU+aM5XrwKZEybkIuLxS2cGGXQJooI+mhdKgKooxB6tSP6KsC9Y+hP6vV5OS8//dFtU3sv7SvPLQit/XZAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716187589; c=relaxed/simple;
	bh=zJeiXIUYemctI6JUyxHh/6l92N7GiddGqsNhdU7mYWQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DTmhPMPB6Q/TRoTHG3sWMB3At4j567vY4pe5nvbvbxBJ3ziQj9MkCFpkJSwJfpZmdouzVnCdGx7SdC4zHE/joaZBxPXNJh5I3Xbfwc8XR9a0UO3vCQfnxC3q+R7M6pvVtSS/1vLutgteYptPAgnwkO/I8KBFZG1CktafaN5R+Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k8oIx/nh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vmqTbn1b; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=k8oIx/nh; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=vmqTbn1b; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8615C33EFA;
	Mon, 20 May 2024 06:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1716187585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JneacqqljGXg+srmnVmYB1aId3PqrqaRgKmSc9R968I=;
	b=k8oIx/nhGpggOZgZC9WeeSbkYSaooUPQX2p5JD8sxPnnlqoG/QuPJ6twzTtCVXToEEocUo
	ZPEstKj82ZOV1nu4ZNDyC34UDhMjYuKOngtvzizlDzHXwhWViCgLzXlOd9nFoNdrof0eBa
	inFy3V3rJt42BhpVl0CaCIpflnc4eRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1716187585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JneacqqljGXg+srmnVmYB1aId3PqrqaRgKmSc9R968I=;
	b=vmqTbn1bpteS/1Y1Ks7YheyXMrzt2it9x7xXuklBDKNwSjgN0hR2kyvV2P1tcO10/Lrw2T
	5uJth6WxtL9+9SCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1716187585; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JneacqqljGXg+srmnVmYB1aId3PqrqaRgKmSc9R968I=;
	b=k8oIx/nhGpggOZgZC9WeeSbkYSaooUPQX2p5JD8sxPnnlqoG/QuPJ6twzTtCVXToEEocUo
	ZPEstKj82ZOV1nu4ZNDyC34UDhMjYuKOngtvzizlDzHXwhWViCgLzXlOd9nFoNdrof0eBa
	inFy3V3rJt42BhpVl0CaCIpflnc4eRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1716187585;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JneacqqljGXg+srmnVmYB1aId3PqrqaRgKmSc9R968I=;
	b=vmqTbn1bpteS/1Y1Ks7YheyXMrzt2it9x7xXuklBDKNwSjgN0hR2kyvV2P1tcO10/Lrw2T
	5uJth6WxtL9+9SCg==
Date: Mon, 20 May 2024 08:46:24 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Wardenjohn <zhangwarden@gmail.com>
cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
In-Reply-To: <20240520005826.17281-1-zhangwarden@gmail.com>
Message-ID: <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.05 / 50.00];
	BAYES_HAM(-2.75)[98.93%];
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
X-Spam-Score: -4.05
X-Spam-Flag: NO

Hi,

On Mon, 20 May 2024, Wardenjohn wrote:

> Livepatch module usually used to modify kernel functions.
> If the patched function have bug, it may cause serious result
> such as kernel crash.
> 
> This is a kobject attribute of klp_func. Sysfs interface named
>  "called" is introduced to livepatch which will be set as true
> if the patched function is called.
> 
> /sys/kernel/livepatch/<patch>/<object>/<function,sympos>/called
> 
> This value "called" is quite necessary for kernel stability
> assurance for livepatching module of a running system.
> Testing process is important before a livepatch module apply to
> a production system. With this interface, testing process can
> easily find out which function is successfully called.
> Any testing process can make sure they have successfully cover
> all the patched function that changed with the help of this interface.

Even easier is to use the existing tracing infrastructure in the kernel 
(ftrace for example) to track the new function. You can obtain much more 
information with that than the new attribute provides.

Regards,
Miroslav

