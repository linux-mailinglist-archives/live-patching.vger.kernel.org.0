Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECE030C428
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 16:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235710AbhBBPnH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 10:43:07 -0500
Received: from verein.lst.de ([213.95.11.211]:46798 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235663AbhBBPmd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 10:42:33 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4164167373; Tue,  2 Feb 2021 16:41:49 +0100 (CET)
Date:   Tue, 2 Feb 2021 16:41:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
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
Message-ID: <20210202154148.GA12433@lst.de>
References: <20210202121334.1361503-1-hch@lst.de> <20210202121334.1361503-11-hch@lst.de> <alpine.LSU.2.21.2102021504550.570@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2102021504550.570@pobox.suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 02, 2021 at 03:07:51PM +0100, Miroslav Benes wrote:
> >  	preempt_disable();
> > -	sym = find_symbol(symbol, &owner, NULL, NULL, true, true);
> > -	if (sym && strong_try_module_get(owner))
> > -		sym = NULL;
> > +	if (!find_symbol(&fsa) || !strong_try_module_get(fsa.owner)) {
> 
> I think this should be in fact
> 
>   if (!find_symbol(&fsa) || strong_try_module_get(fsa.owner)) {
> 
> to get the logic right (note the missing !). We want to return NULL if 
> strong_try_module_get() does not succeed for a found symbol.

Indeed. Fixed for the next version.
