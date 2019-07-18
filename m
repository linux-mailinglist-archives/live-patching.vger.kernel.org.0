Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBF6E6CB8C
	for <lists+live-patching@lfdr.de>; Thu, 18 Jul 2019 11:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfGRJIC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Jul 2019 05:08:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:52048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfGRJIB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Jul 2019 05:08:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9942AF95;
        Thu, 18 Jul 2019 09:08:00 +0000 (UTC)
Date:   Thu, 18 Jul 2019 11:08:00 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/5] livepatch: Allow to distinguish different version of
 system state changes
Message-ID: <20190718090800.gd2neswknsnmey2h@pathway.suse.cz>
References: <20190611135627.15556-1-pmladek@suse.com>
 <20190611135627.15556-4-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611135627.15556-4-pmladek@suse.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2019-06-11 15:56:25, Petr Mladek wrote:
> It might happen that an older change is not enough and the same system
> state has to be modified another way. Different changes need to get
> distinguished by a version number added to struct klp_state.
> 
> The version can also be used to prevent loading incompatible livepatches.
> The check is done when the livepatch is enabled. The rules are:
> 
>   + Any completely new system state modification is allowed.
> 
>   + System state modifications with the same or higher version are allowed
>     for already modified system states.
> 
>   + Cumulative livepatches must handle all system state modifications from
>     already installed livepatches.
> 
>   + Non-cumulative livepatches are allowed to touch already modified
>     system states.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>
> ---
>  include/linux/livepatch.h |  2 ++
>  kernel/livepatch/core.c   |  8 ++++++++
>  kernel/livepatch/state.c  | 40 +++++++++++++++++++++++++++++++++++++++-
>  kernel/livepatch/state.h  |  9 +++++++++
>  4 files changed, 58 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/livepatch/state.h
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 591abdee30d7..8bc4c6cc3f3f 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -135,10 +135,12 @@ struct klp_object {
>  /**
>   * struct klp_state - state of the system modified by the livepatch
>   * @id:		system state identifier (non zero)
> + * @version:	version of the change (non-zero)
>   * @data:	custom data
>   */
>  struct klp_state {
>  	int id;

As suggested by Nicolay, there will be in v2:

	unsigned long id;

> +	int version;

It would make sense to make "version" unsigned as well.
I am just unsure about the size:

  + "unsigned long" looks like an overhead to me
  + "u8" might be enough

But I would stay on the safe side and use:

	unsigned int version;

Is anyone against?

Best Regards,
Petr
