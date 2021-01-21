Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A502FF1EF
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 18:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbhAUR2f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 12:28:35 -0500
Received: from verein.lst.de ([213.95.11.211]:33361 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388335AbhAURME (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 12:12:04 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 91AEA68B05; Thu, 21 Jan 2021 18:11:19 +0100 (CET)
Date:   Thu, 21 Jan 2021 18:11:19 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
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
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 02/13] module: add a module_loaded helper
Message-ID: <20210121171119.GA29916@lst.de>
References: <20210121074959.313333-1-hch@lst.de> <20210121074959.313333-3-hch@lst.de> <844a7fc3-2cba-46d2-fd4e-e5fe16b08573@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <844a7fc3-2cba-46d2-fd4e-e5fe16b08573@csgroup.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 21, 2021 at 11:00:20AM +0100, Christophe Leroy wrote:
> > +bool module_loaded(const char *name);
>
> Maybe module_is_loaded() would be a better name.

Fine with me.
