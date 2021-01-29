Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6B43087E3
	for <lists+live-patching@lfdr.de>; Fri, 29 Jan 2021 11:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhA2KaZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Jan 2021 05:30:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:52594 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232282AbhA2K0S (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Jan 2021 05:26:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611914657; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qNxzpumQOIuAdqIOWix8LagkCKY10qlSAVohdhIWCVg=;
        b=s0Jljl1gns8wLO9nXDS+CpmTLJ+z+ETchZ3Bs350di4FEOEEZeHSpbMlCueoIW9JJMb9W4
        VmFPnZC8KoLJyVf3sHmKgIToROzuPgGFbf2mjw1SJTTThlW9qvL1gLd/m13ngQbc+7RGqo
        iyQbIW7CxAsNNLuIEHKxQtodn/uN7xQ=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AD9ACAF7A;
        Fri, 29 Jan 2021 10:04:17 +0000 (UTC)
Date:   Fri, 29 Jan 2021 11:04:17 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 04/13] module: use RCU to synchronize find_module
Message-ID: <YBPdocTviQc2aaC5@alley>
References: <20210128181421.2279-1-hch@lst.de>
 <20210128181421.2279-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128181421.2279-5-hch@lst.de>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-01-28 19:14:12, Christoph Hellwig wrote:
> Allow for a RCU-sched critical section around find_module, following
> the lower level find_module_all helper, and switch the two callers
> outside of module.c to use such a RCU-sched critical section instead
> of module_mutex.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It looks good and safe.

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
