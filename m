Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7D4307A54
	for <lists+live-patching@lfdr.de>; Thu, 28 Jan 2021 17:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbhA1QKo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Jan 2021 11:10:44 -0500
Received: from verein.lst.de ([213.95.11.211]:57915 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232072AbhA1QKm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Jan 2021 11:10:42 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id A3B7068AFE; Thu, 28 Jan 2021 17:09:57 +0100 (CET)
Date:   Thu, 28 Jan 2021 17:09:57 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 13/13] module: remove EXPORY_UNUSED_SYMBOL*
Message-ID: <20210128160957.GA2504@lst.de>
References: <20210121074959.313333-1-hch@lst.de> <20210121074959.313333-14-hch@lst.de> <YBFvcmUiHRjkucbf@gunter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBFvcmUiHRjkucbf@gunter>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 27, 2021 at 02:49:38PM +0100, Jessica Yu wrote:
>> #ifdef CONFIG_MODULE_SIG
>> 	/* Signature was verified. */
>> 	bool sig_ok;
>> @@ -592,7 +580,6 @@ struct symsearch {
>> 		GPL_ONLY,
>> 		WILL_BE_GPL_ONLY,
>> 	} license;
>> -	bool unused;
>> };

> Thanks for the cleanups. While we're here, I noticed that struct
> symsearch is only used internally in kernel/module.c, so I don't think
> it actually needs to be in include/linux/module.h. I don't see it used
> anywhere else. We could move maybe that to kernel/module-internal.h.

I've added a patch to just move it directly into module.c.
