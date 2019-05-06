Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106EE14BA2
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2019 16:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEFOQS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 May 2019 10:16:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbfEFOQS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 May 2019 10:16:18 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D6DDD81DFA;
        Mon,  6 May 2019 14:16:17 +0000 (UTC)
Received: from treble (ovpn-122-172.rdu2.redhat.com [10.10.122.172])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59F6A17152;
        Mon,  6 May 2019 14:16:12 +0000 (UTC)
Date:   Mon, 6 May 2019 09:16:08 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, live-patching@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch/docs: Convert livepatch documentation to
 the ReST format
Message-ID: <20190506141608.2o6blbcklinjc7r4@treble>
References: <20190503143024.28358-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190503143024.28358-1-pmladek@suse.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 06 May 2019 14:16:18 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 03, 2019 at 04:30:22PM +0200, Petr Mladek wrote:
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
> 
>  Documentation/ABI/testing/sysfs-kernel-livepatch   |   2 +-
>  .../livepatch/{callbacks.txt => callbacks.rst}     |  45 +--
>  ...mulative-patches.txt => cumulative-patches.rst} |  14 +-
>  Documentation/livepatch/index.rst                  |  21 ++
>  .../livepatch/{livepatch.txt => livepatch.rst}     |  62 ++--
>  ...module-elf-format.txt => module-elf-format.rst} | 353 +++++++++++----------
>  .../livepatch/{shadow-vars.txt => shadow-vars.rst} |  65 ++--
>  tools/objtool/Documentation/stack-validation.txt   |   2 +-
>  8 files changed, 307 insertions(+), 257 deletions(-)
>  rename Documentation/livepatch/{callbacks.txt => callbacks.rst} (87%)
>  rename Documentation/livepatch/{cumulative-patches.txt => cumulative-patches.rst} (89%)
>  create mode 100644 Documentation/livepatch/index.rst
>  rename Documentation/livepatch/{livepatch.txt => livepatch.rst} (93%)
>  rename Documentation/livepatch/{module-elf-format.txt => module-elf-format.rst} (55%)
>  rename Documentation/livepatch/{shadow-vars.txt => shadow-vars.rst} (87%)

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
