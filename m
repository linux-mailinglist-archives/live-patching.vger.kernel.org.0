Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF832307AC6
	for <lists+live-patching@lfdr.de>; Thu, 28 Jan 2021 17:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhA1QZm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Jan 2021 11:25:42 -0500
Received: from verein.lst.de ([213.95.11.211]:58020 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232136AbhA1QZi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Jan 2021 11:25:38 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 968EA68B02; Thu, 28 Jan 2021 17:24:47 +0100 (CET)
Date:   Thu, 28 Jan 2021 17:24:46 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
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
Subject: Re: [PATCH 03/13] livepatch: refactor klp_init_object
Message-ID: <20210128162446.GA3883@lst.de>
References: <20210121074959.313333-1-hch@lst.de> <20210121074959.313333-4-hch@lst.de> <YBFjbbuQ7sn4T7yT@alley> <20210128162240.GA3417@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128162240.GA3417@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 28, 2021 at 05:22:40PM +0100, Christoph Hellwig wrote:
> > We need to either update the function description or keep this check.
> > 
> > I prefer to keep the check. The function does the right thing also
> > for the object "vmlinux". Also the livepatch code includes many
> > similar paranoid checks that makes the code less error prone
> > against any further changes.
> 
> Well, the check is in the caller now where we have a conditional for
> it.  So I'd be tempted to either update the comment, or just drop the
> patch.

Also even without the check I think it will do the right thing when
called for vmlinux given that it simplify won't find a module called
vmlinux..
