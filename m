Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C756030D5B5
	for <lists+live-patching@lfdr.de>; Wed,  3 Feb 2021 09:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232996AbhBCI7X (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Feb 2021 03:59:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:56288 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232880AbhBCI7W (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Feb 2021 03:59:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612342715; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d0+x7egL9Qu9DyTDy1qWd3xGJ1Te9iPGoSgdl08Km7U=;
        b=WCS08+UTloQ8w9V9X07PshoidPrR3T0C1D8IT5lGC/Kr+EZJ6BkxmCkeJefyLiTP8qjIqm
        L73CpIywNQvgnRWI+YV3bh4QkOhpY1J1sxsIa7QBjlU9wJ7cEAQaiI1JSwb9Elv3FGGM2s
        k1KiS9e6wuNM+KE+AaDQDSKhT09Igb0=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AA166AC45;
        Wed,  3 Feb 2021 08:58:35 +0000 (UTC)
Date:   Wed, 3 Feb 2021 09:58:34 +0100
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
Subject: Re: [PATCH 05/13] kallsyms: refactor
 {,module_}kallsyms_on_each_symbol
Message-ID: <YBplukHLyaxTjrpV@alley>
References: <20210202121334.1361503-1-hch@lst.de>
 <20210202121334.1361503-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202121334.1361503-6-hch@lst.de>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2021-02-02 13:13:26, Christoph Hellwig wrote:
> Require an explicit call to module_kallsyms_on_each_symbol to look
> for symbols in modules instead of the call from kallsyms_on_each_symbol,
> and acquire module_mutex inside of module_kallsyms_on_each_symbol instead
> of leaving that up to the caller.  Note that this slightly changes the
> behavior for the livepatch code in that the symbols from vmlinux are not
> iterated anymore if objname is set, but that actually is the desired
> behavior in this case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Miroslav Benes <mbenes@suse.cz>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
