Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2B330D65F
	for <lists+live-patching@lfdr.de>; Wed,  3 Feb 2021 10:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhBCJcy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 3 Feb 2021 04:32:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:54596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233511AbhBCJcV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 3 Feb 2021 04:32:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 56585AD24;
        Wed,  3 Feb 2021 09:31:37 +0000 (UTC)
Date:   Wed, 3 Feb 2021 10:31:36 +0100 (CET)
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
Subject: Re: [PATCH 10/13] module: pass struct find_symbol_args to
 find_symbol
In-Reply-To: <20210203090418.GA7833@lst.de>
Message-ID: <alpine.LSU.2.21.2102031031120.24713@pobox.suse.cz>
References: <20210202121334.1361503-1-hch@lst.de> <20210202121334.1361503-11-hch@lst.de> <alpine.LSU.2.21.2102021504550.570@pobox.suse.cz> <20210203090418.GA7833@lst.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 3 Feb 2021, Christoph Hellwig wrote:

> FYI, this is the updated version:
> 
> ---
> >From 664ca3378deac7530fe8fc15fe73d583d3333df2 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Wed, 20 Jan 2021 14:58:27 +0100
> Subject: module: pass struct find_symbol_args to find_symbol
> 
> Simplify the calling convention by passing the find_symbol_args structure
> to find_symbol instead of initializing it inside the function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

M
