Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B46B2FE506
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 09:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbhAUIaw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 03:30:52 -0500
Received: from verein.lst.de ([213.95.11.211]:59568 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbhAUI3R (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 03:29:17 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 94E3E67373; Thu, 21 Jan 2021 09:28:20 +0100 (CET)
Date:   Thu, 21 Jan 2021 09:28:20 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Daniel Vetter <daniel@ffwll.ch>
Cc:     Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        live-patching@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH 08/13] drm: remove drm_fb_helper_modinit
Message-ID: <20210121082820.GA25719@lst.de>
References: <20210121074959.313333-1-hch@lst.de> <20210121074959.313333-9-hch@lst.de> <CAKMK7uFo3epNAUdcp0vvW=VyWMMTZghGyRTPbz_Z37S6nem_2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uFo3epNAUdcp0vvW=VyWMMTZghGyRTPbz_Z37S6nem_2A@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 21, 2021 at 09:25:40AM +0100, Daniel Vetter wrote:
> On Thu, Jan 21, 2021 at 8:55 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > drm_fb_helper_modinit has a lot of boilerplate for what is not very
> > simple functionality.  Just open code it in the only caller using
> > IS_ENABLED and IS_MODULE.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I didn't spot any dependencies with your series, should I just merge
> this through drm trees? Or do you want an ack?

I'd prefer an ACK - module_loaded() is only introduced earlier in this
series.
