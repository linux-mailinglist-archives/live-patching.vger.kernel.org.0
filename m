Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF4516D6D
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2019 00:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfEGWNA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 May 2019 18:13:00 -0400
Received: from ms.lwn.net ([45.79.88.28]:47368 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbfEGWNA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 May 2019 18:13:00 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 3A104316;
        Tue,  7 May 2019 22:12:59 +0000 (UTC)
Date:   Tue, 7 May 2019 16:12:58 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch/docs: Convert livepatch documentation to
 the ReST format
Message-ID: <20190507161258.0c8dd3c8@lwn.net>
In-Reply-To: <20190503143024.28358-1-pmladek@suse.com>
References: <20190503143024.28358-1-pmladek@suse.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri,  3 May 2019 16:30:22 +0200
Petr Mladek <pmladek@suse.com> wrote:

> This is the original Mauro's patch and my extra fixup as a clean
> patchset.
> 
> I want to be sure that other livepatching maintainers are fine
> with the changes ;-)
> 
> 
> Mauro Carvalho Chehab (1):
>   docs: livepatch: convert docs to ReST and rename to *.rst
> 
> Petr Mladek (1):
>   docs/livepatch: Unify style of livepatch documentation in the ReST
>     format

I've applied the set, thanks.  It would be good to get it linked into the
main doctree, though.  Not quite sure where to put it; perhaps the
core-api manual is as good as any for now?

Thanks,

jon
