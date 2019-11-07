Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB4EF31D0
	for <lists+live-patching@lfdr.de>; Thu,  7 Nov 2019 15:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbfKGOy3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Nov 2019 09:54:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:49064 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726640AbfKGOy3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Nov 2019 09:54:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7F90AD07;
        Thu,  7 Nov 2019 14:54:27 +0000 (UTC)
Date:   Thu, 7 Nov 2019 15:54:27 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] x86/stacktrace: update kconfig help text for reliable
 unwinders
Message-ID: <20191107145427.7ycihdipfijwxenw@pathway.suse.cz>
References: <20191107032958.14034-1-joe.lawrence@redhat.com>
 <20191107033458.ptvw6omypqndjt6d@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107033458.ptvw6omypqndjt6d@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2019-11-06 21:34:58, Josh Poimboeuf wrote:
> On Wed, Nov 06, 2019 at 10:29:58PM -0500, Joe Lawrence wrote:
> > commit 6415b38bae26 ("x86/stacktrace: Enable HAVE_RELIABLE_STACKTRACE
> > for the ORC unwinder") added the ORC unwinder as a "reliable" unwinder.
> > Update the help text to reflect that change: the frame pointer unwinder
> > is no longer the only one that can provide HAVE_RELIABLE_STACKTRACE.
> > 
> > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> 
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

It is committed in livepatch.git, branch for-5.5/core.

Best Regards,
Petr
