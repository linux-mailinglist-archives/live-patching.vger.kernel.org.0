Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 885B430C9E4
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 19:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238612AbhBBScN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 13:32:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:41032 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233826AbhBBOF0 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 09:05:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4F287ABD5;
        Tue,  2 Feb 2021 14:04:44 +0000 (UTC)
Date:   Tue, 2 Feb 2021 15:04:43 +0100 (CET)
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
Subject: Re: [PATCH 09/13] module: merge each_symbol_section into
 find_symbol
In-Reply-To: <20210202121334.1361503-10-hch@lst.de>
Message-ID: <alpine.LSU.2.21.2102021504310.570@pobox.suse.cz>
References: <20210202121334.1361503-1-hch@lst.de> <20210202121334.1361503-10-hch@lst.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 2 Feb 2021, Christoph Hellwig wrote:

> each_symbol_section is only called by find_symbol, so merge the two
> functions.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Miroslav Benes <mbenes@suse.cz>

M
