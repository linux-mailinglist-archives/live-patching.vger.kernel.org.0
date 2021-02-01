Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB4C30A74D
	for <lists+live-patching@lfdr.de>; Mon,  1 Feb 2021 13:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhBAMLd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Feb 2021 07:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231158AbhBAML3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Feb 2021 07:11:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7928C64E2C;
        Mon,  1 Feb 2021 12:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612181448;
        bh=VpXCDfyNDkFB6N2oS+yv9UYv1FFtVEhcO5B6o8eybU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HaH7mujAr3wAdUU7Wbx8NZL1I+ehA6nkr8Ywa4kIYDvUwHUoZx2E28Pxr7ifUj0mt
         7ljJAQsR2C8cmJAhCEfFz7WlBbFbcYk6h1CXB2Y9PzQv9yo4WszIpL5OHIbr+huud/
         DTJ+YupZxs4692+MeXtltnemY6HxUucQSaELW53wykG+dmhx/UvhvmlITS+Idy3evG
         6qzrY4zJuBmI9bQgKtqj9S8Vxz3ss0nQSNYmw9hIaMuF6P5GYtPl/DuUcSxMjQJcLy
         tT307SwHtzy9d8kG545Zqjsb+38DqN6yFxfRVMnwI9dVoBzO/0f1HxxpxD93Q+NZid
         37O97iC4kLFKA==
Date:   Mon, 1 Feb 2021 13:10:37 +0100
From:   Jessica Yu <jeyu@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 04/13] module: use RCU to synchronize find_module
Message-ID: <YBfvvdna9pSeu+1g@gunter>
References: <20210128181421.2279-1-hch@lst.de>
 <20210128181421.2279-5-hch@lst.de>
 <alpine.LSU.2.21.2101291626080.22237@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2101291626080.22237@pobox.suse.cz>
X-OS:   Linux gunter 5.10.9-1-default x86_64
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Miroslav Benes [29/01/21 16:29 +0100]:
>On Thu, 28 Jan 2021, Christoph Hellwig wrote:
>
>> Allow for a RCU-sched critical section around find_module, following
>> the lower level find_module_all helper, and switch the two callers
>> outside of module.c to use such a RCU-sched critical section instead
>> of module_mutex.
>
>That's a nice idea.
>
>> @@ -57,7 +58,7 @@ static void klp_find_object_module(struct klp_object *obj)
>>  	if (!klp_is_module(obj))
>>  		return;
>>
>> -	mutex_lock(&module_mutex);
>> +	rcu_read_lock_sched();
>>  	/*
>>  	 * We do not want to block removal of patched modules and therefore
>>  	 * we do not take a reference here. The patches are removed by
>> @@ -74,7 +75,7 @@ static void klp_find_object_module(struct klp_object *obj)
>>  	if (mod && mod->klp_alive)
>
>RCU always baffles me a bit, so I'll ask. Don't we need
>rcu_dereference_sched() here? "mod" comes from a RCU-protected list, so I
>wonder.

Same here :-) I had to double check the RCU documentation. For our
modules list case I believe the rcu list API should take care of that
for us. Worth noting is this snippet from Documentation/RCU/whatisRCU.txt:

    rcu_dereference() is typically used indirectly, via the _rcu
    list-manipulation primitives, such as list_for_each_entry_rcu()


