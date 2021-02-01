Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C53630A94A
	for <lists+live-patching@lfdr.de>; Mon,  1 Feb 2021 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbhBAODZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Feb 2021 09:03:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:49688 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231511AbhBAODY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Feb 2021 09:03:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8740DAB92;
        Mon,  1 Feb 2021 14:02:41 +0000 (UTC)
Date:   Mon, 1 Feb 2021 15:02:40 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 05/13] kallsyms: refactor
 {,module_}kallsyms_on_each_symbol
In-Reply-To: <20210128181421.2279-6-hch@lst.de>
Message-ID: <alpine.LSU.2.21.2102011500300.21637@pobox.suse.cz>
References: <20210128181421.2279-1-hch@lst.de> <20210128181421.2279-6-hch@lst.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

One more thing...

> @@ -4379,8 +4379,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
>  	unsigned int i;
>  	int ret;
>  
> -	module_assert_mutex();
> -
> +	mutex_lock(&module_mutex);
>  	list_for_each_entry(mod, &modules, list) {
>  		/* We hold module_mutex: no need for rcu_dereference_sched */
>  		struct mod_kallsyms *kallsyms = mod->kallsyms;

This was the last user of module_assert_mutex(), which can be removed now.

Miroslav
