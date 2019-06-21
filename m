Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A89AE4EB68
	for <lists+live-patching@lfdr.de>; Fri, 21 Jun 2019 17:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfFUPAT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 21 Jun 2019 11:00:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUPAT (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 21 Jun 2019 11:00:19 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B80F30C0DED;
        Fri, 21 Jun 2019 15:00:14 +0000 (UTC)
Received: from redhat.com (ovpn-121-168.rdu2.redhat.com [10.10.121.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D18605B689;
        Fri, 21 Jun 2019 15:00:10 +0000 (UTC)
Date:   Fri, 21 Jun 2019 11:00:08 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/5] livepatch: Allow to distinguish different version of
 system state changes
Message-ID: <20190621142156.GF20356@redhat.com>
References: <20190611135627.15556-1-pmladek@suse.com>
 <20190611135627.15556-4-pmladek@suse.com>
 <20190621140911.GC20356@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621140911.GC20356@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 21 Jun 2019 15:00:19 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 21, 2019 at 10:09:11AM -0400, Joe Lawrence wrote:
> More word play: would it be any clearer to drop the use of
> "modification" when talking about klp_states?  Sometimes I read
> modification to mean a change to a klp_state itself rather than the
> system at large.

After reading through the rest of the series, maybe I was premature
about this.  "System state modification" is used consistently throughout
the series, so without having any better suggestion, ignore my comment.

-- Joe
