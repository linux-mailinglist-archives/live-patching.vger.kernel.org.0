Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6340013109
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 17:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfECPRf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 11:17:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17221 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbfECPRf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 11:17:35 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 981AE3313EA6;
        Fri,  3 May 2019 15:17:34 +0000 (UTC)
Received: from redhat.com (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A4EC50DDB;
        Fri,  3 May 2019 15:17:32 +0000 (UTC)
Date:   Fri, 3 May 2019 11:17:30 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, live-patching@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch/docs: Convert livepatch documentation to
 the ReST format
Message-ID: <20190503151730.GC24094@redhat.com>
References: <20190503143024.28358-1-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503143024.28358-1-pmladek@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 03 May 2019 15:17:35 +0000 (UTC)
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
> 
> -- 
> 2.16.4
> 

Hi Petr,

From a quick look at the 'make htmldocs' output, these look good.

I did notice that callbacks.rst updated "commit ("desc")" formatting,
but shadow-vars.rst did not.  If you want to defer that nitpick until a
larger formatting linting, I'd be fine with that.

Regards,

-- Joe
