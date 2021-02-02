Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2E130C3AB
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 16:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhBBPZU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 10:25:20 -0500
Received: from verein.lst.de ([213.95.11.211]:46712 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235105AbhBBPYf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 10:24:35 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4FA6068AFE; Tue,  2 Feb 2021 16:23:46 +0100 (CET)
Date:   Tue, 2 Feb 2021 16:23:45 +0100
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
Subject: Re: module loader dead code removal and cleanups v3
Message-ID: <20210202152345.GA11849@lst.de>
References: <20210202121334.1361503-1-hch@lst.de> <YBljkDgMFcqKcH8H@gunter>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBljkDgMFcqKcH8H@gunter>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 02, 2021 at 03:37:04PM +0100, Jessica Yu wrote:
> The patchset looks good so far. After Miroslav's comments are
> addressed, I'll wait an extra day or two in case there are more
> comments before queueing them onto modules-next. I can take the first
> two patches as well provided the acks are there (I think patch 2 is
> missing Daniel Vetter's ack from v1 of the series, but I'll add that
> back in).

I did remove the find_module entirely compared to v1, so I'd prefer
another explicit ACK for the new version.
